//
//  Workout.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 22/12/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation

protocol WorkoutRepresentable {
    var _laps: String { get }
    var _rounds: String { get }
    var _roundTime: String { get }
    var _restTime: String { get }
    var _totalTime: String { get }
    var readyToStart: Bool { get }
    func copyModifying(laps: Int?, rounds: Int?, roundTime: Int?, restTime: Int?) -> Workout
}

struct Workout {
    var laps: Int = 1
    var rounds: Int = 1
    var roundTime: Int = 0
    var restTime: Int = 0
    var totalTime: Int { (roundTime + restTime) * rounds * laps }
}

extension Workout: WorkoutRepresentable {
    var _laps: String { String(laps) }
    
    var _rounds: String { String(rounds) }
    
    var _roundTime: String { toString(TimeInterval(roundTime)) }
    
    var _restTime: String { toString(TimeInterval(restTime)) }
    
    var _totalTime: String { toString(TimeInterval(totalTime)) }
    
    var readyToStart: Bool { roundTime > 0 }
    
    func copyModifying(laps: Int?, rounds: Int?, roundTime: Int?, restTime: Int?) -> Workout {
        Workout(
            laps: laps ?? self.laps,
            rounds: rounds ?? self.rounds,
            roundTime: roundTime ?? self.roundTime,
            restTime: restTime ?? self.restTime
        )
    }
    
    private func toString(_ interval: TimeInterval) -> String {
        if interval > 3599 {
            return DateComponentsFormatter.fullStyle.string(from: interval) ?? ""
        } else {
            return DateComponentsFormatter.shortStyle.string(from: interval) ?? ""
        }
    }
}
