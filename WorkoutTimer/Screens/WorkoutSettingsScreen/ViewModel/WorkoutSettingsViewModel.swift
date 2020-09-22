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
    func setSetsNumber(_ sets: Int)
    func setRoundsNumber(_ rounds: Int)
}
protocol WorkoutSettingsViewModelOutputs {
    var roundTime: BehaviorSubject<TimeInterval> { get }
    var restTime: BehaviorSubject<TimeInterval> { get }
}

class WorkoutSettingsViewModel: WorkoutSettingsViewModelType, WorkoutSettingsViewModelInputs, WorkoutSettingsViewModelOutputs {
    
    // MARK: - Object Properties
    
    private var _roundTime: Double = 0
    private var _restTime: Double = 0
    private var _sets: Int = 1
    private var _rounds: Int = 1
    
    // MARK: - Object Methods
    
    func toSecondts(minutes: Int, seconds: Int) -> Double {
        return Double(60 * minutes + seconds)
    }
    
    
    // MARK: - Inputs/Outputs
    
    func setWorkoutTime(_ minutes: Int, _ seconds: Int) {
        _roundTime = toSecondts(minutes: minutes, seconds: seconds)
        roundTime.onNext(_roundTime)
    }
    
    func setRestTime(_ minutes: Int, _ seconds: Int) {
        _restTime = toSecondts(minutes: minutes, seconds: seconds)
        restTime.onNext(_restTime)
    }
    
    func setSetsNumber(_ sets: Int) {
        _sets = sets
        self.sets.onNext(_sets)
    }
    
    func setRoundsNumber(_ rounds: Int) {
        _rounds = rounds
        self.rounds.onNext(_rounds)
    }
    
    var roundTime = BehaviorSubject<TimeInterval>(value: 0)
    var restTime = BehaviorSubject<TimeInterval>(value: 0)
    var sets = BehaviorSubject<Int>(value: 1)
    var rounds = BehaviorSubject<Int>(value: 1)
    var totalWorkoutTime = BehaviorSubject<TimeInterval>(value: 0)
    
    
    
    
    init() { }
    
    
    // MARK: - Inputs/Outputs
    
    var inputs: WorkoutSettingsViewModelInputs { return self }
    
    var outputs: WorkoutSettingsViewModelOutputs { return self }
    
}
