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
    
    lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 25)
        label.textAlignment = .left
        label.textColor = ColorPalette.primary.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var itemValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Heavy", size: 50)
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
        setupView()
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
    
    func setupView() {
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
            itemTitleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 8),
            itemTitleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor),
            itemTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: centerXAnchor, constant: -16),
            itemTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            itemValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor, constant: 16),
            itemValueLabel.heightAnchor.constraint(equalTo: margins.heightAnchor),
            itemValueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -8),
            itemValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
