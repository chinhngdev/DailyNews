//
//  ArticleDetailViewController.swift
//  DailyNews
//
//  Created by Chinh on 7/23/25.
//

import UIKit
import WebKit
import SnapKit

final class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ArticleDetailViewModel!

    // MARK: - UI
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        loadArticle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Setup
private extension ArticleDetailViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupWebView()
    }
    
    func setupWebView() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        title = viewModel.articleTitle
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - Actions
private extension ArticleDetailViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Loading
private extension ArticleDetailViewController {
    func loadArticle() {
        guard let urlString = viewModel.articleURL,
              let url = URL(string: urlString) else {
            showError(message: "Invalid article URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Show loading indicator if needed
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide loading indicator if needed
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError(message: "Failed to load article: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showError(message: "Failed to load article: \(error.localizedDescription)")
    }
}

// MARK: - Factory Method
extension ArticleDetailViewController {
    public class func instantiate(with viewModel: ArticleDetailViewModel) -> ArticleDetailViewController {
        let viewController = ArticleDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
