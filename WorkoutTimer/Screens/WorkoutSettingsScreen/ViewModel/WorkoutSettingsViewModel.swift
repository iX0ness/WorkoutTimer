//
//  WorkoutSettingsViewModel.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation
import RxSwift

class WorkoutSettingsViewModel {
    var workoutTime = BehaviorSubject(value: Time())
    
    init() { }
    
    
}
