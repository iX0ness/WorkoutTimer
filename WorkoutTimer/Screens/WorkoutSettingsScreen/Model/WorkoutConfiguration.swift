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
    
    @Unit(initialValue: 1, 1...99)
    var sets: Int
    
    @Unit(initialValue: 1, 1...99)
    var laps: Int
}
