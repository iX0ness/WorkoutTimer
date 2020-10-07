//
//  TimeInputViewController.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 19/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum Input {
    case workoutTime
    case restTime
    case sets
    case laps
}

class TimeInputViewController: UIViewController, Storyboarded, InputConfigurable {
    
    // MARK: - IB Outlets
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - View Properties -
    
    // MARK: Main Input Container
    
    lazy var mainInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK:  Primary Input Container
    
    lazy var primaryInputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            primaryTextField,
            primaryDescriptionLabel,
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var primaryTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    lazy var primaryDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK:  Secondary Input Container
    
    lazy var secondaryInputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            secondaryTextField,
            secondaryDescriptionLabel,
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var secondaryTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    lazy var secondaryDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Object properties
    
    var primaryTextFiedInput: Int {
        return zeroOrInputNumber(primaryTextField.text)
    }
    
    var secondaryTextFiedInput: Int {
        return zeroOrInputNumber(secondaryTextField.text)
    }
    
    private var unit = Unit(initialValue: 0, 0...99)
    
    var popupTitle: String
    var inputType: InputType
    var inputParameter: InputParameter
    
    // MARK: - Object Lifecycle
    
    required init?(coder: NSCoder) {
        self.popupTitle = ""
        self.inputType = .double
        self.inputParameter = .workoutTime
        super.init(coder: coder)
    }
    
    deinit { print("Deinitialized") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewShape()
        configureView()
        titleLabel.text = popupTitle
    }
    
    // MARK: - IB Actions
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dismissGestureAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: - UI Settings

private extension TimeInputViewController {
    func setupViewShape() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
    
    func zeroOrInputNumber(_ inputValue: String?) -> Int {
        guard let input = inputValue else { return 0 }
        unit.wrappedValue = Int(input) ?? 0
        return unit.value
    }

}

