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
    private var viewModel: NewListViewModel!
    
    // MARK: - UI Components
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
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
    
    @MainActor
    private func setupViewModel() {
        viewModel = NewListViewModel()
        
        // Setup callbacks để update UI
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }
        
        viewModel.onArticlesUpdated = { articles in
            // TODO: Update tableView
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
