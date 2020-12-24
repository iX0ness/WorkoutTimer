//
//  MainCoordinator.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let timerMainViewController = WorkoutSettingsViewController.instantiate()
        timerMainViewController.coordinator = self
        timerMainViewController.viewModel = WorkoutSettingsViewModel()
        navigationController.pushViewController(timerMainViewController, animated: true)
    }
    
    func showInputPopup(_ title: String, _ inputType: InputType, _ inputParameter: InputParameter) -> TimeInputViewController {
        let popupViewController = TimeInputViewController.instantiate(title: title, for: inputType, with: inputParameter)
        popupViewController.modalPresentationStyle = .popover
        popupViewController.modalTransitionStyle = .coverVertical
        return popupViewController
    }

    func showCountdownTimerViewController(for workout: Workout) {
        let workoutSettingsViewController = TimerMainViewController.instantiate()
        workoutSettingsViewController.viewModel = TimerMainViewModel(workout: workout, player: SoundPlayer(), configurator: WorkoutConfigurator.self)
        navigationController.pushViewController(workoutSettingsViewController, animated: true)
    }
}
