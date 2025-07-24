//
//  ArticleDetailViewController.swift
//  DailyNews
//
//  Created by Chinh on 7/23/25.
//

import UIKit

final class ArticleDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ArticleDetailViewController {
    public class func instantiate() -> ArticleDetailViewController {
        let viewController = ArticleDetailViewController()
        return viewController
    }
}
