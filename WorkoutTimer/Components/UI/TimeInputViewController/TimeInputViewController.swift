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

class TimeInputViewController: UIViewController, Storyboarded, InputConfigurable, UITextFieldDelegate {
    
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
        textField.delegate = self
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
    
    var inputType: InputType
    
    // MARK: - Object Lifecycle
    
    required init?(coder: NSCoder) {
        self.inputType = .double
        super.init(coder: coder)
    }
    
    deinit {
        print("Deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewShape()
        configureView()
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
}
