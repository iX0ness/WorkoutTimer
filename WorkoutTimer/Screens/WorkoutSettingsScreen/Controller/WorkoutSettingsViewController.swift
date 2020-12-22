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
    var viewModel: WorkoutSettingsViewModelType?
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var workConfigView: WorkoutItemView!
    @IBOutlet weak var restConfigView: WorkoutItemView!
    @IBOutlet weak var setsConfigView: WorkoutItemView!
    @IBOutlet weak var lapsConfigView: WorkoutItemView!
    @IBOutlet weak var workoutConfigStackView: UIStackView!
    
    @IBOutlet weak var totalWorkoutTimeView: UIView!
    @IBOutlet weak var totalWorkoutTimeLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    // MARK: - IB Actions
    
    @IBAction func tapGestureWorkoutConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
            title: "Enter time",
            inputType: .double,
            inputParameter: .workoutTime) else { return }
        handleInput(of: popup)
    }
    @IBAction func tapGestureRestConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
                title: "Enter time",
                inputType: .double,
                inputParameter: .restTime) else { return }
        handleInput(of: popup)
    }
    
    @IBAction func tapGestureSetsConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
                title: "Enter rounds",
                inputType: .single(primaryPlaceholder: "1",
                                   priparyDescription: "sets"),
                inputParameter: .sets) else { return }
        handleInput(of: popup)
    }
    
    @IBAction func tapGestureLapsConfigView(_ sender: UITapGestureRecognizer) {
        guard let popup = showPopup(
                title: "Enter laps",
                inputType: .single(primaryPlaceholder: "1",
                                   priparyDescription: "laps"),
                inputParameter: .laps) else { return }
        handleInput(of: popup)
    }
    
    @IBAction func startWorkout(_ sender: UIButton) {
        guard let value = try? viewModel?.outputs.workout.value(),
              let workout = value as? Workout,
              workout.readyToStart else { return }
        
        self.coordinator?.showCountdownTimerViewController(for: workout)
    }
    
    // MARK: - Object Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindWorkout()
    }

    private let disposeBag = DisposeBag()
}

// MARK: - UI Settings

private extension WorkoutSettingsViewController {
    func setupView() {
        view.backgroundColor = ColorPalette.subsecondary.color
        setupTotalWorkoutView()
        activateStartWorkoutButtonConstraints()
    }
    
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
            startWorkoutButton.bottomAnchor.constraint(
                equalTo: workoutConfigStackView.topAnchor,
                constant: bottomAnchorConstant
            ),
        ])
    }
}

// MARK: - Object Functions

private extension WorkoutSettingsViewController {
    
    func handleInput(of popup: TimeInputViewController) {
        popup.confirmButton.rx.tap.bind { [weak popup] in
            guard let popup = popup else { return }
            switch popup.inputParameter {
            case .workoutTime:
                self.viewModel?.inputs.setWorkoutTime(
                    popup.primaryTextFiedInput,
                    popup.secondaryTextFiedInput)
            case .restTime:
                self.viewModel?.inputs.setRestTime(popup.primaryTextFiedInput, popup.secondaryTextFiedInput)
            case .sets:
                self.viewModel?.inputs.setRounds(popup.primaryTextFiedInput)
            case .laps:
                self.viewModel?.inputs.setLaps(popup.primaryTextFiedInput)
            }
        }.disposed(by: disposeBag)
        
    }
    
    func bindWorkout() {
        viewModel?.outputs.workout
            .subscribe(onNext: { [weak self] workout in
                self?.lapsConfigView.valueText = workout._laps
                self?.setsConfigView.valueText = workout._rounds
                self?.restConfigView.valueText = workout._restTime
                self?.workConfigView.valueText = workout._roundTime
                self?.totalWorkoutTimeLabel.text = workout._totalTime
            }).disposed(by: disposeBag)
    }
    
    func showPopup(title: String, inputType: InputType, inputParameter: InputParameter) -> TimeInputViewController? {
        guard let popupViewController = coordinator?.showInputPopup(title, inputType, inputParameter) else { return nil }
        present(popupViewController, animated: true, completion: nil)
        return popupViewController
    }
}
