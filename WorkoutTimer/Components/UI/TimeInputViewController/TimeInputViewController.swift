//
//  TimeInputViewController.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 19/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit

class TimeInputViewController: UIViewController, Storyboarded {

    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        setupViewShape()
    }
    
    override func viewDidLayoutSubviews() {
        view.frame = CGRect(x: view.frame.midX - 100, y: view.frame.midY - 75, width: 200, height: 150)
    }
    
}

// MARK: - UI Settings

private extension TimeInputViewController {
//    func setupDismissButton() {
//        dismissButton.backgroundColor = ColorPalette.secondary.color
//    }
    
    func setupViewShape() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
}
