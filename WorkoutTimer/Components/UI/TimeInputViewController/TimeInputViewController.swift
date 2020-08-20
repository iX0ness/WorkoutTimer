//
//  TimeInputViewController.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 19/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

class TimeInputViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        setupDismissButton()
        setupViewShape()
    }
    
}

// MARK: - UI Settings

private extension TimeInputViewController {
    func setupDismissButton() {
        dismissButton.backgroundColor = ColorPalette.secondary.color
    }
    
    func setupViewShape() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
}
