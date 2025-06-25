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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Test API Configuration
        print("🔍 Testing API Configuration:")
        print("   - newsAPIBaseURL: \(APIConfiguration.newsAPIBaseURL)")
        APIConfiguration.printConfigurationInfo()
        
        Task {
            do {
                let news = try await getNews()
                print(news)
            } catch {
                print(error)
            }
        }
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

    private func getNews() async throws -> ArticleResponse {
        var urlComponents = URLComponents(string: APIConfiguration.newsAPIBaseURL)
        urlComponents?.path = "/everything"
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: "technology"),
            URLQueryItem(name: "sortBy", value: "relevancy"),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "page", value: "1")
        ]

        // Khi urlCoponents?.url được gọi thì Swift sẽ tự động xây dựng URL hoàn chỉnh bao gồm cả query parameters từ queryItems
        // Ví dụ: https://newsapi.org/v2/everything?q=technology&sortBy=relevancy&pageSize=20&page=1
        guard let url = urlComponents?.url else {
            throw NewsListError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(APIConfiguration.newsAPIKey, forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NewsListError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let news = try decoder.decode(ArticleResponse.self, from: data)
            return news
        } catch {
            throw NewsListError.invalidData
        }
    }
}

enum NewsListError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
