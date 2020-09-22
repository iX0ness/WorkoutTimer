//
//  Time.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 21/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

struct Time {
    @Unit(initialValue: 0, 0...99)
    var minutes: Int
    
    @Unit(initialValue: 0, 0...99)
    var seconds: Int
    
    
}


