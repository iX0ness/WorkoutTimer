//
//  WorkoutItemView.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 17/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

@IBDesignable
final class WorkoutItemView: UIView {
    
    private lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold",
                            size: ViewMetrics.ItemTitleLabel.fontSize)
        label.textAlignment = .left
        label.textColor = ColorPalette.primary.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var itemValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Heavy",
                            size: ViewMetrics.ItemValueLabel.fontSize)
        label.textAlignment = .right
        label.textColor = ColorPalette.primary.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        
    }
    
    @IBInspectable
    var titleText: String = "" {
        didSet {
            itemTitleLabel.text = titleText
        }
    }
    
    @IBInspectable
    var valueText: String = "" {
        didSet {
            itemValueLabel.text = valueText
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
}

// MARK: - UI Settings

private extension WorkoutItemView {
    func setupView() {
        backgroundColor = ColorPalette.subprimary.color
        layer.masksToBounds = true
        addSubviews()
        activateConstraints()
    }
    
    func addSubviews() {
        addSubview(itemTitleLabel)
        addSubview(itemValueLabel)
    }
    
    func activateConstraints() {
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            itemTitleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor,
                                                    constant: ViewMetrics.ItemTitleLabel.paddingLeading),
            itemTitleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor),
            itemTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: centerXAnchor,
                                                     constant: ViewMetrics.ItemTitleLabel.paddingTrailing),
            itemTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            itemValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor,
                                                    constant: ViewMetrics.ItemValueLabel.paddingLeading),
            itemValueLabel.heightAnchor.constraint(equalTo: margins.heightAnchor),
            itemValueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor,
                                                     constant: ViewMetrics.ItemValueLabel.paddingTrailing),
            itemValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    enum ViewMetrics {
        enum ItemTitleLabel {
            static let paddingLeading: CGFloat = 8
            static let paddingTrailing: CGFloat = -16
            static let fontSize: CGFloat = 25
        }
        
        enum ItemValueLabel {
            static let paddingLeading: CGFloat = 16
            static let paddingTrailing: CGFloat = -8
            static let fontSize: CGFloat = 30
        }
    }
}
