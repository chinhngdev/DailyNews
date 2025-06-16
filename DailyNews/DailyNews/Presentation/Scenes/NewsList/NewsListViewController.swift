//
//  NewsListViewController.swift
//  DailyNews
//
//  Created by Chinh on 6/16/25.
//

import UIKit

final class NewsListViewController: UIViewController {
    weak var coordinator: NewsListCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
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
