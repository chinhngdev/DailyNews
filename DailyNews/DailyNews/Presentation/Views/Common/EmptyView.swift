//
//  EmptyView.swift
//  DailyNews
//
//  Created by Chinh on 8/7/25.
//

import UIKit
import SnapKit

/// A reusable view for displaying empty states with an icon, title, and message
final class EmptyView: UIView {
    
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = AppSpacing.medium.value
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    convenience init(icon: UIImage?, title: String, message: String) {
        self.init(frame: .zero)
        configure(icon: icon, title: title, message: message)
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(AppSpacing.large.value)
        }
        
        // Add icon with size constraints
        stackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(64)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
    }
    
    // MARK: - Configuration
    func configure(icon: UIImage?, title: String, message: String) {
        iconImageView.image = icon
        iconImageView.isHidden = icon == nil
        titleLabel.text = title
        messageLabel.text = message
    }
    
    /// Show the empty view with optional animation
    func show(animated: Bool = true) {
        guard animated else {
            // Show the view immediately without animation
            isHidden = false
            alpha = 1.0
            return
        }
        
        // Show the view with fade in/out animation
        isHidden = false
        alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    /// Hide the empty view with optional animation
    func hide(animated: Bool = true) {
        guard animated else {
            // Hide the view immediately without animation
            isHidden = true
            alpha = 0.0
            return
        }
        
        // Hide the view with fade in/out animation
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { _ in
            self.isHidden = true
        }
    }
}
