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
        timerMainViewController.callPopup = showPopup
        timerMainViewController.coordinator = self
        navigationController.pushViewController(timerMainViewController, animated: true)
    }
    
    private func showPopup() -> TimeInputViewController {
        let popupViewController = TimeInputViewController.instantiate()
        popupViewController.modalPresentationStyle = .popover
        popupViewController.modalTransitionStyle = .coverVertical
        return popupViewController
    }

//    func workoutSettingsViewControllerStart() {
//        let workoutSettingsViewController = WorkoutSettingsViewController.instantiate()
//        navigationController.pushViewController(workoutSettingsViewController, animated: true)
//    }
}
