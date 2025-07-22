//
//  NewsListViewController.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

final class NewsListViewController: UIViewController {
    // MARK: - Properties
    weak var coordinator: NewsListCoordinator?
    private var viewModel: NewsListViewModel!
    
    // MARK: - UI Components
    private lazy var newsListView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(NewsItemTableViewCell.self)
        return tableView
    }()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Properties
    private var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupViewModel()
        viewModel.fetchNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Test API Configuration
        print("🔍 Testing API Configuration:")
        print("   - newsAPIBaseURL: \(APIConfiguration.newsAPIBaseURL)")
        APIConfiguration.printConfigurationInfo()
    }
    
    private func setupViewModel() {
        viewModel = NewsListViewModel()
        
        // Setup callbacks để update UI
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }
        
        viewModel.onArticlesUpdated = { [weak self] articles in
            self?.articles = articles
            self?.newsListView.reloadData()
            print("Loaded \(articles.count) articles")
        }
        
        viewModel.onErrorChanged = { [weak self] errorMessage in
            if let error = errorMessage {
                self?.showError(error)
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Daily News"

        view.addSubview(newsListView)
        newsListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Add loading indicator
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
    }
    
    private func setupNavigationBar() {
        // Add search button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchButtonTapped)
        )
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        coordinator?.showSearch()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Thử lại", style: .default) { [weak self] _ in
            self?.viewModel.fetchNews()
        })
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        present(alert, animated: true)
    }
    
    /// Be triggered when user taps on an article
    private func didSelectArticle(_ article: Article) {
        coordinator?.showNewsDetail(article)
    }
}

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
