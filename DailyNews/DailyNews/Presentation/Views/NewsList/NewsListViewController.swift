//
//  NewsListViewController.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

protocol NewsListViewControllerDelegate: AnyObject {
    func didSelectArticle(_ viewController: NewsListViewController, _ article: Article)
}

final class NewsListViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: NewsListViewModel!
    weak var delegate: NewsListViewControllerDelegate?

    // addtional properties:
    private var articles: [Article] = []

    // MARK: - UI Components
    private lazy var newsListView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsItemTableViewCell.self)
        return tableView
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10n.commonSearch
        searchController.searchBar.delegate = self
        return searchController
    }()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.configureForNewsEmpty()
        emptyView.isHidden = true
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindToViewModel()
        viewModel.fetchNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Test API Configuration
        print("🔍 Testing API Configuration:")
        print("   - newsAPIBaseURL: \(APIConfiguration.newsAPIBaseURL)")
        APIConfiguration.printConfigurationInfo()
    }
    
    private func bindToViewModel() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if let isLoading = isLoading, isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }
        
        viewModel.onArticlesUpdated = { [weak self] articles in
            self?.articles = articles
            self?.newsListView.reloadData()
            self?.updateEmptyViewVisibility()
            print("✅ Loaded \(articles.count) articles")
        }
        
        viewModel.onErrorChanged = { [weak self] errorMessage in
            if let error = errorMessage {
                self?.showError(error)
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = L10n.tabbarNews

        view.addSubview(newsListView)
        newsListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Add loading indicator
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        
        // Add empty view
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.commonClose, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.commonTryAgain, style: .default) { [weak self] _ in
            self?.viewModel.fetchNews()
        })
        alert.addAction(UIAlertAction(title: L10n.commonClose, style: .cancel))
        present(alert, animated: true)
    }
    
    /// Be triggered when user taps on an article
    private func didSelectArticle(_ article: Article) {
        delegate?.didSelectArticle(self, article)
    }
    
    /// Update empty view visibility based on articles array
    private func updateEmptyViewVisibility() {
        if articles.isEmpty {
            emptyView.show(animated: true)
            newsListView.isHidden = true
        } else {
            emptyView.hide(animated: true)
            newsListView.isHidden = false
        }
    }
}

// MARK: - TableView data source & delegate

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NewsItemTableViewCell.self, for: indexPath)
        cell.configure(with: articles[indexPath.row])
        return cell
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        didSelectArticle(article)
    }
}

// MARK: - UISearchBarDelegate
extension NewsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchQuery = searchBar.text
        viewModel.searchNews(with: searchQuery)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchNews() // Load original news when search is cancelled
        searchBar.resignFirstResponder()
    }
}

// MARK: - Constructors
extension NewsListViewController {
    public static func instantiate(
        with viewModel: NewsListViewModel,
        delegate: NewsListViewControllerDelegate?
    ) -> NewsListViewController {
        let viewController = NewsListViewController()
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
}

extension EmptyView {
    func configureForNewsEmpty() {
        let icon = UIImage(systemName: "newspaper")
        configure(
            icon: icon,
            title: L10n.emptyNewsTitle,
            message: L10n.emptyNewsMessage
        )
    }
}