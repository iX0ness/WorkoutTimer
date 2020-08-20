//
//  WorkoutSettingsViewController.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

class WorkoutSettingsViewController: UIViewController, Storyboarded {
    
    // MARK: - Stored properties
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var workConfigView: WorkoutItemView!
    @IBOutlet weak var restConfigView: WorkoutItemView!
    @IBOutlet weak var setsConfigView: WorkoutItemView!
    @IBOutlet weak var roundsConfigView: WorkoutItemView!
    @IBOutlet weak var workoutConfigStackView: UIStackView!
    
    @IBOutlet weak var totalWorkoutTimeView: UIView!
    @IBOutlet weak var totalWorkoutTimeLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    
    
    var callPopup: (() -> TimeInputViewController)?
    
    // MARK: - Object Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
    
    
    
    @IBAction func action(_ sender: Any) {
        guard let popupViewController = callPopup?() else { return }
        popupViewController.view.frame = view.frame
        present(popupViewController, animated: true, completion: nil)
    }
    
    
   
    
}

// MARK: - UI Settings

private extension WorkoutSettingsViewController {
    
    func addGestureRecognizer() {
        
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
            startWorkoutButton.bottomAnchor.constraint(equalTo: workoutConfigStackView.topAnchor, constant: bottomAnchorConstant)
        ])
    }
}
