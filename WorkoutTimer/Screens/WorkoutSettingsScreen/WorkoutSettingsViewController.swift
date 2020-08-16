//
//  WorkoutSettingsViewController.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

class WorkoutSettingsViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?

    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = ColorPalette.subsecondary.color
        testView.backgroundColor = ColorPalette.secondary.color
        timeValueLabel.textColor = ColorPalette.primary.color
        timeDescriptionLabel.textColor = ColorPalette.primary.color
        
        testView.layer.cornerRadius = 10
        testView.layer.masksToBounds = true
    }

}
