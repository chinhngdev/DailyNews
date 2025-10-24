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
    
    // additional properties
    private var newsSources: [NewsSource] = []

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
        viewModel.fetchNewsSources()
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
        viewModel.onSourcesUpdated = { [weak self] newsSources in
            self?.newsSources.append(contentsOf: newsSources)
            self?.favouriteSourcesTableView.reloadData()
        }
    }
}

extension FavouriteSourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSources.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteSourceTableViewCell.reuseIdentifier, for: indexPath) as! FavouriteSourceTableViewCell
        let source = newsSources[indexPath.row]
        cell.configure(with: source)
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
