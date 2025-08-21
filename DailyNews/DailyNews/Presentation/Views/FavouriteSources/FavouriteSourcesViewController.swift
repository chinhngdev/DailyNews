//
//  FavouriteSourcesViewController.swift
//  DailyNews
//
//  Created by Chinh on 8/6/25.
//

import UIKit

protocol FavouriteSourcesViewControllerDelegate: AnyObject {}

final class FavouriteSourcesViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: FavouriteSourcesViewModel!
    private weak var delegate: FavouriteSourcesViewControllerDelegate?

    // MARK: - UI Components
    private lazy var favouriteSourcesTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteSourceTableViewCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindToViewModel()
    }

    private func setupUI() {
        view.addSubview(favouriteSourcesTableView)
        favouriteSourcesTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = L10n.tabbarFavourite
    }
    
    private func bindToViewModel() {
    }
}

extension FavouriteSourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteSourceTableViewCell.reuseIdentifier, for: indexPath) as! FavouriteSourceTableViewCell
        return cell
    }
}

extension FavouriteSourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Constructors
extension FavouriteSourcesViewController {
    public static func instantiate(
        with viewModel: FavouriteSourcesViewModel,
        delegate: FavouriteSourcesViewControllerDelegate?
    ) -> FavouriteSourcesViewController {
        let viewController = FavouriteSourcesViewController()
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
}
