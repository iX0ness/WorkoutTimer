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
    func setSets(_ count: Int)
    func setLaps(_ count: Int)
}
protocol WorkoutSettingsViewModelOutputs {
    var roundTime: BehaviorSubject<String> { get }
    var restTime: BehaviorSubject<String> { get }
    var sets: BehaviorSubject<String> { get }
    var laps: BehaviorSubject<String> { get }
    var totalWorkoutTime: BehaviorSubject<String> { get }
}

class WorkoutSettingsViewModel: WorkoutSettingsViewModelType, WorkoutSettingsViewModelInputs, WorkoutSettingsViewModelOutputs {
    
    // MARK: - Object Properties
    
    private var _roundTime: Double = 0 {
        didSet {
            totalWorkoutTime.onNext(string(of: totalTime))
        }
    }
    private var _restTime: Double = 0 {
        didSet {
            totalWorkoutTime.onNext(string(of: totalTime))
        }
    }
    private var _sets: Int = 1 {
        didSet {
            totalWorkoutTime.onNext(string(of: totalTime))
        }
    }
    private var _laps: Int = 1 {
        didSet {
            totalWorkoutTime.onNext(string(of: totalTime))
        }
    }
    
    private var totalTime: Double {
        (_roundTime + _restTime) * Double(_sets * _laps)
    }
    
    // MARK: - Object Methods
    
    
    // MARK: - Inputs/Outputs
    
    func setWorkoutTime(_ minutes: Int, _ seconds: Int) {
        _roundTime = toSeconds(minutes: minutes, seconds: seconds)
        roundTime.onNext(string(of: _roundTime))
    }
    
    func setRestTime(_ minutes: Int, _ seconds: Int) {
        _restTime = toSeconds(minutes: minutes, seconds: seconds)
        restTime.onNext(string(of: _restTime))
    }
    
    func setSets(_ count: Int) {
        _sets = count
        sets.onNext(String(_sets))
    }
    
    func setLaps(_ count: Int) {
        _laps = count
        laps.onNext(String(_laps))
    }
    
    var roundTime = BehaviorSubject<String>(value: "00:00")
    var restTime = BehaviorSubject<String>(value: "00:00")
    var sets = BehaviorSubject<String>(value: "1")
    var laps = BehaviorSubject<String>(value: "1")
    var totalWorkoutTime = BehaviorSubject<String>(value: "00:00:00")
    
    init() { }
    
    // MARK: - Inputs/Outputs
    
    var inputs: WorkoutSettingsViewModelInputs { return self }
    var outputs: WorkoutSettingsViewModelOutputs { return self }
    
    
}


// MARK: - Helper functions
extension WorkoutSettingsViewModel {
    func string(of interval: TimeInterval) -> String {
        if interval > 3599 {
            return DateComponentsFormatter.fullStyle.string(from: interval) ?? ""
        } else {
            return DateComponentsFormatter.shortStyle.string(from: interval) ?? ""
        }
    }
    
    func toSeconds(minutes: Int, seconds: Int) -> Double {
        return Double(60 * minutes + seconds)
    }
}
