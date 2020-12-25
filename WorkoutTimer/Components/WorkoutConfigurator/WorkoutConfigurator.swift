//
//  WorkoutConfigurator.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 24/12/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

struct WorkoutConfigurator {
    
    init() {}
    
    private func set(roundTime: Int, restTime: Int) -> [[WorkoutPhase]] {
        return [
            (0...roundTime).map { WorkoutPhase.action($0) },
            (0...restTime).map { WorkoutPhase.rest($0) },
        ]
    }
    
    private func multiRoundSet(rounds: Int, roundTime: Int, restTime: Int) -> [[WorkoutPhase]] {
        return (0..<rounds)
            .map { _ in set(roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
        
    }
    
    private func multiLapSet(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [[WorkoutPhase]] {
        return (0..<laps)
            .map { _ in multiRoundSet(rounds: rounds, roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
        
    }
    
    func configure(_ workout: Workout) -> [WorkoutPhase] {
        switch (workout.laps, workout.rounds) {
        case (1, 1):
            return set(roundTime: workout.roundTime,
                       restTime: workout.restTime
            )
            .dropLast()
            .flatMap { $0 }
            
        case (1, 1...):
            return multiRoundSet(rounds: workout.rounds,
                                 roundTime: workout.roundTime,
                                 restTime: workout.restTime
            )
            .dropLast()
            .flatMap { $0 }
            
        case (2..., 1...):
            return multiLapSet(
                laps: workout.laps,
                rounds: workout.rounds,
                roundTime: workout.roundTime,
                restTime: workout.restTime
            )
            .dropLast()
            .flatMap { $0 }
            
        default:
            fatalError(
                """
            Unexpected number of laps or rounds
            Laps: \(workout.laps) | Rounds: \(workout.rounds)
            """)
        }
        
    }
}
