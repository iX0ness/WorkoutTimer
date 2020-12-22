//
//  WorkoutSettingsViewModel.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation
import RxSwift

protocol WorkoutSettingsViewModelType {
    var inputs: WorkoutSettingsViewModelInputs { get }
    var outputs: WorkoutSettingsViewModelOutputs { get }
}
protocol WorkoutSettingsViewModelInputs {
    func setWorkoutTime(_ minutes: Int, _ seconds: Int)
    func setRestTime(_ minutes: Int, _ seconds: Int)
    func setRounds(_ count: Int)
    func setLaps(_ count: Int)
}
protocol WorkoutSettingsViewModelOutputs {
    var workout: BehaviorSubject<WorkoutRepresentable> { get }
}

class WorkoutSettingsViewModel: WorkoutSettingsViewModelType, WorkoutSettingsViewModelInputs, WorkoutSettingsViewModelOutputs {
    
    let workout: BehaviorSubject<WorkoutRepresentable>
    
    init() {
        workout = BehaviorSubject(value: Workout())
    }
    
    func setWorkoutTime(_ minutes: Int, _ seconds: Int) {
        let time = toSeconds(minutes: minutes, seconds: seconds)
        emitWorkout(roundTime: time)
    }
    
    func setRestTime(_ minutes: Int, _ seconds: Int) {
        let time = toSeconds(minutes: minutes, seconds: seconds)
        emitWorkout(restTime: time)
    }
    
    func setRounds(_ count: Int) {
       emitWorkout(rounds: count)
    }
    
    func setLaps(_ count: Int) {
        emitWorkout(laps: count)
    }
    
    var inputs: WorkoutSettingsViewModelInputs { return self }
    var outputs: WorkoutSettingsViewModelOutputs { return self }
}

// MARK: - Helper functions
private extension WorkoutSettingsViewModel {
    func toSeconds(minutes: Int, seconds: Int) -> Int {
        return 60 * minutes + seconds
    }
    
    private func emitWorkout(laps: Int? = nil, rounds: Int? = nil, roundTime: Int? = nil, restTime: Int? = nil) {
        guard let value = try? workout.value() else { return }
        workout.onNext(value.copyModifying(laps: laps, rounds: rounds, roundTime: roundTime, restTime: restTime))
    }
}


