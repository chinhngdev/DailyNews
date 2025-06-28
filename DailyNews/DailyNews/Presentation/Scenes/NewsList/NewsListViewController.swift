//
//  NewsListViewController.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

final class NewsListViewController: UIViewController {
    weak var coordinator: NewsListCoordinator?
    var viewModel: NewListViewModel = NewListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()

        Task {
            do {
                try await viewModel.fetchNews()
            } catch {
                print("Failed to fetch news.")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Test API Configuration
        print("🔍 Testing API Configuration:")
        print("   - newsAPIBaseURL: \(APIConfiguration.newsAPIBaseURL)")
        APIConfiguration.printConfigurationInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Daily News"
    }
    
    private func setupNavigationBar() {
        // Add search button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchButtonTapped)
        )
    }
    
    @objc private func searchButtonTapped() {
        coordinator?.showSearch()
    }
    
    /// Be triggered when user taps on an article
    private func didSelectArticle(_ article: Article) {
        coordinator?.showNewsDetail(article)
    }
}
