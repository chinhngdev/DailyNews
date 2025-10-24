//
//  FavouriteSourceTableViewCell.swift
//  DailyNews
//
//  Created by Chinh on 8/21/25.
//

import UIKit
import SnapKit

final class FavouriteSourceTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var newsSourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = AppFont.headline.font
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(AppSpacing.mediumSmall.value)
        }
        
        containerView.addSubview(newsSourceLabel)
        newsSourceLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(AppSpacing.mediumSmall.value)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension FavouriteSourceTableViewCell {
    func configure(with newsSource: NewsSource) {
        newsSourceLabel.text = newsSource.name
    }
}
