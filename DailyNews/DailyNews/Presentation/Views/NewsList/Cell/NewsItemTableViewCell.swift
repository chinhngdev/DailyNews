//
//  NewsItemTableViewCell.swift
//  DailyNews
//
//  Created by Chinh on 7/20/25.
//

import UIKit
import SnapKit
import TCAssets

final class NewsItemTableViewCell: UITableViewCell {
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var articleSourceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        return label
    }()
    
    private lazy var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.headline.font
        return label
    }()

    private lazy var publishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(articleImageView)
        articleImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(articleSourceLabel)
        articleSourceLabel.snp.makeConstraints {
            $0.top.equalTo(articleImageView.snp.bottom).offset(AppSpacing.small.value)
            $0.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(articleTitleLabel)
        articleTitleLabel.snp.makeConstraints {
            $0.top.equalTo(articleSourceLabel.snp.bottom).offset(AppSpacing.small.value)
            $0.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(publishedAtLabel)
        publishedAtLabel.snp.makeConstraints {
            $0.top.equalTo(articleTitleLabel.snp.bottom).offset(AppSpacing.small.value)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension NewsItemTableViewCell {
    func configure(with article: Article) {
        articleImageView.image = Asset.Images.rickSanchez.image
        articleSourceLabel.text = article.source.name
        articleTitleLabel.text = article.title
        publishedAtLabel.text = article.publishedAt
    }
}
