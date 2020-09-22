//
//  WorkoutSettingsViewController.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit
import RxSwift

class WorkoutSettingsViewController: UIViewController, Storyboarded {
    
    // MARK: - Stored properties
    
    weak var coordinator: MainCoordinator?
    var viewModel: WorkoutSettingsViewModel?
    
    
    let disposeBag = DisposeBag()
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var workConfigView: WorkoutItemView!
    @IBOutlet weak var restConfigView: WorkoutItemView!
    @IBOutlet weak var setsConfigView: WorkoutItemView!
    @IBOutlet weak var roundsConfigView: WorkoutItemView!
    @IBOutlet weak var workoutConfigStackView: UIStackView!
    
    @IBOutlet weak var totalWorkoutTimeView: UIView!
    @IBOutlet weak var totalWorkoutTimeLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    // MARK: - Object Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeWorkoutConfiguration()
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func startWorkoutAction(_ sender: UIButton) {
        
    }
    
    // MARK: - Object Methods
    
    func setupView() {
        view.backgroundColor = ColorPalette.subsecondary.color
        setupTotalWorkoutView()
        activateStartWorkoutButtonConstraints()
    }
    
    @IBAction func tapGestureWorkoutConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
            title: "Enter time",
            inputType: .double,
            inputParameter: .workoutTime
        ) else { return }
        handleInput(of: popup)
    }
    @IBAction func tapGestureRestConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
                title: "Enter time",
                inputType: .double,
                inputParameter: .restTime)
        else { return }
        handleInput(of: popup)
        
    }
    
    @IBAction func tapGestureSetsConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
                title: "Enter sets",
                inputType: .single(primaryPlaceholder: "1",
                                   priparyDescription: "sets"),
                inputParameter: .sets) else { return }
        handleInput(of: popup)
    }
    
    @IBAction func tapGestureRoundsConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
                title: "Enter rounds",
                inputType: .single(primaryPlaceholder: "1",
                                   priparyDescription: "rounds"),
                inputParameter: .rounds) else { return }
        handleInput(of: popup)
    }
    
    
    private func showPopup(title: String, inputType: InputType, inputParameter: InputParameter) -> TimeInputViewController? {
        guard let popupViewController = coordinator?.showInputPopup(title, inputType, inputParameter) else { return nil }
        present(popupViewController, animated: true, completion: nil)
        return popupViewController
    }
}

// MARK: - UI Settings

private extension WorkoutSettingsViewController {
    
    func setupTotalWorkoutView() {
        totalWorkoutTimeView.backgroundColor = ColorPalette.subprimary.color
        totalWorkoutTimeView.clipsToBounds = true
        totalWorkoutTimeView.layer.cornerRadius = 10
        totalWorkoutTimeLabel.textColor = ColorPalette.primary.color
    }
    
    func activateStartWorkoutButtonConstraints() {
        let buttonSide = UIScreen.valueForHeight(x568: 75, x667: nil, x736: 120, x812: nil, x896: nil)
        let bottomAnchorConstant = UIScreen.valueForHeight(x568: -16, x667: nil, x736: nil, x812: nil, x896: nil)
        
        startWorkoutButton.layer.cornerRadius = buttonSide / 2
        startWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startWorkoutButton.widthAnchor.constraint(equalToConstant: buttonSide),
            startWorkoutButton.heightAnchor.constraint(equalToConstant: buttonSide),
            startWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startWorkoutButton.bottomAnchor.constraint(equalTo: workoutConfigStackView.topAnchor, constant: bottomAnchorConstant)
        ])
    }
}

extension WorkoutSettingsViewController {
    func handleInput(of popup: TimeInputViewController) {
        popup.confirmButton.rx.tap.bind { [weak popup] in
            guard let popup = popup else { return }
            switch popup.inputParameter {
            case .workoutTime:
                self.viewModel?.inputs.setWorkoutTime(popup.primaryTextFiedInput, popup.secondaryTextFiedInput)
            case .restTime:
                self.viewModel?.inputs.setRestTime(popup.primaryTextFiedInput, popup.secondaryTextFiedInput)
            case .sets:
                self.viewModel?.inputs.setSetsNumber(popup.primaryTextFiedInput)
            case .rounds:
                self.viewModel?.inputs.setRoundsNumber(popup.primaryTextFiedInput)
            }
            
        }.disposed(by: disposeBag)
    }
    
    func observeWorkoutConfiguration() {
        viewModel?.roundTime
            .map(toTimeString(_:))
            .subscribe(onNext: { [weak self] time in
                self?.workConfigView.valueText = time
            }).disposed(by: disposeBag)
        
        viewModel?.restTime
            .map(toTimeString(_:))
            .subscribe(onNext: { [weak self] time in
                self?.restConfigView.valueText = time
            }).disposed(by: disposeBag)
        
        viewModel?.sets
            .subscribe(onNext: { [weak self] sets in
                self?.setsConfigView.valueText = String(sets)
            }).disposed(by: disposeBag)
        
        viewModel?.rounds
            .subscribe(onNext: { [weak self] rounds in
                self?.roundsConfigView.valueText = String(rounds)
            }).disposed(by: disposeBag)
        
    }
    
    func toTimeString(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        if interval > 3599 {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval)!
    }
}
