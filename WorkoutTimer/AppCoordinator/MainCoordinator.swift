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
    
    func showInputPopup(_ inputType: InputType) -> TimeInputViewController {
        let popupViewController = TimeInputViewController.instantiate(for: inputType)
        popupViewController.modalPresentationStyle = .popover
        popupViewController.modalTransitionStyle = .coverVertical
        return popupViewController
    }

//    func workoutSettingsViewControllerStart() {
//        let workoutSettingsViewController = WorkoutSettingsViewController.instantiate()
//        navigationController.pushViewController(workoutSettingsViewController, animated: true)
//    }
}
