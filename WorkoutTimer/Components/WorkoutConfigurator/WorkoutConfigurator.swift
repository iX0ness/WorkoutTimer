//
//  WorkoutConfigurator.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 24/12/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

struct WorkoutConfigurator {
    
    private init() {}
    
    private static func set(roundTime: Int, restTime: Int) -> [[WorkoutPhase]] {
        return [(0...roundTime).map { WorkoutPhase.action($0) }, (0...restTime).map { WorkoutPhase.rest($0) }]
    }
    
    private static func multiRoundSet(rounds: Int, roundTime: Int, restTime: Int) -> [[WorkoutPhase]] {
        return (0...rounds)
            .map { _ in set(roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
    }
    
    private static func multiLapSet(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [[WorkoutPhase]] {
        return (0...laps)
            .map { _ in multiRoundSet(rounds: rounds, roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
    }
    
    static func configureWorkout(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [WorkoutPhase] {
        switch (laps, rounds) {
        case (1, 1):
            return set(roundTime: roundTime, restTime: restTime).dropLast().flatMap { $0 }
            
        case (1, 1...):
            return multiRoundSet(rounds: rounds, roundTime: roundTime, restTime: restTime).dropLast().flatMap { $0 }
            
        case (2..., 1...):
            return multiLapSet(laps: laps, rounds: rounds, roundTime: roundTime, restTime: restTime).dropLast().flatMap { $0 }
            
        default:
            fatalError(
                """
            Unexpected number of laps or rounds
            Laps: \(laps) | Rounds: \(rounds)
            """)
        }
        
    }
}
