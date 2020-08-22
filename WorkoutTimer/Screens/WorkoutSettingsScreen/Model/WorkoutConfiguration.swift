//
//  WorkoutConfiguration.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 21/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

struct WorkoutConfiguration {
    let workoutTime: Time
    let restTime: Time
    
    @Unit(initialValue: 0, 0...99)
    var sets: Int
    
    @Unit(initialValue: 0, 0...99)
    var rounds: Int
}
