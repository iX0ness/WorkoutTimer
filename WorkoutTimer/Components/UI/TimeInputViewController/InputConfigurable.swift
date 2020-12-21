//
//  InputConfigurable.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 22/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

enum InputParameter {
    case workoutTime
    case restTime
    case sets
    case laps
}

enum InputType {
    case single(primaryPlaceholder: String, priparyDescription: String)
    case double
}

protocol InputConfigurable {
    var inputType: InputType { get set }
}

extension InputConfigurable where Self: TimeInputViewController {
    func configureView() {
        constructHierarchy()
        activateConstraints()
        switch inputType {
        case .single(
                primaryPlaceholder: let primaryPlaceholderText,
                priparyDescription: let primaryDescriptionText):
            configureTextFields(primaryPlaceholder: primaryPlaceholderText)
            configureDescriptionLabels(primaryLabelText: primaryDescriptionText)
        case .double:
            configureTextFields()
            configureDescriptionLabels()
        }
    }
    
    private func configureTextFields(primaryPlaceholder: String = "00", secondaryPlaceholder: String = "00") {
        primaryTextField.keyboardType = .numberPad
        primaryTextField.textAlignment = .center
        primaryTextField.backgroundColor = .white
        primaryTextField.textColor = .lightGray
        primaryTextField.attributedPlaceholder = NSAttributedString(
            string: primaryPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.placeholder.color]
        )
        secondaryTextField.keyboardType = .numberPad
        secondaryTextField.textAlignment = .center
        secondaryTextField.backgroundColor = .white
        secondaryTextField.textColor = .lightGray
        secondaryTextField.attributedPlaceholder = NSAttributedString(
            string: secondaryPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.placeholder.color]
        )
    }
    
    private func configureDescriptionLabels(primaryLabelText: String = "minutes", secondaryLabelText: String = "seconds") {
        primaryDescriptionLabel.text = primaryLabelText
        primaryDescriptionLabel.textColor = ColorPalette.primary.color
        primaryDescriptionLabel.font = UIFont(name: "AvenirNext-Medium ", size: 17)
        
        secondaryDescriptionLabel.text = secondaryLabelText
        secondaryDescriptionLabel.textColor = ColorPalette.primary.color
        secondaryDescriptionLabel.font = UIFont(name: "AvenirNext-Medium ", size: 17)
        
    }
    
    private func constructHierarchy() {
        containerView.addSubview(mainInputStackView)
        switch inputType {
        case .single(primaryPlaceholder: _, priparyDescription: _):
            mainInputStackView.addArrangedSubview(primaryInputStackView)
        case .double:
            mainInputStackView.addArrangedSubview(primaryInputStackView)
            mainInputStackView.addArrangedSubview(secondaryInputStackView)
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            mainInputStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            mainInputStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }
}
