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

    @IBOutlet weak var workConfigView: WorkoutItemView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.subsecondary.color
        
        
    }

}
