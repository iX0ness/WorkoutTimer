//
//  WorkoutState.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 16/12/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

enum WorkoutState {
    case inProgress(WorkoutPhase)
    case paused
    case finished
}

enum WorkoutPhase {
    case action(Int)
    case rest(Int)
    
    var value: Int {
        switch self {
        case .action(let value):
            return value
        case .rest(let value):
            return value
        }
    }
}
