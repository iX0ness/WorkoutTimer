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
    var workout: BehaviorSubject<Workout> { get }
}

class WorkoutSettingsViewModel: WorkoutSettingsViewModelType, WorkoutSettingsViewModelInputs, WorkoutSettingsViewModelOutputs {
    
    var roundTime = BehaviorSubject<String>(value: "00:00")
    var restTime = BehaviorSubject<String>(value: "00:00")
    var sets = BehaviorSubject<String>(value: "1")
    var laps = BehaviorSubject<String>(value: "1")
    var totalWorkoutTime = BehaviorSubject<String>(value: "00:00:00")
    var workout: BehaviorSubject<Workout>
    
    init() {
        workout = BehaviorSubject(value: Workout(laps: _laps, rounds: _sets, roundTime: _roundTime, restTime: _restTime))
    }
    
    func setWorkoutTime(_ minutes: Int, _ seconds: Int) {
        _roundTime = toSeconds(minutes: minutes, seconds: seconds)
        roundTime.onNext(string(of: TimeInterval(_roundTime)))
        workout.onNext(Workout(laps: _laps, rounds: _sets, roundTime: _roundTime, restTime: _restTime))
    }
    
    func setRestTime(_ minutes: Int, _ seconds: Int) {
        _restTime = toSeconds(minutes: minutes, seconds: seconds)
        restTime.onNext(string(of: TimeInterval(_restTime)))
        workout.onNext(Workout(laps: _laps, rounds: _sets, roundTime: _roundTime, restTime: _restTime))
    }
    
    func setSets(_ count: Int) {
        _sets = count
        sets.onNext(String(_sets))
        workout.onNext(Workout(laps: _laps, rounds: _sets, roundTime: _roundTime, restTime: _restTime))
    }
    
    func setLaps(_ count: Int) {
        _laps = count
        laps.onNext(String(_laps))
        workout.onNext(Workout(laps: _laps, rounds: _sets, roundTime: _roundTime, restTime: _restTime))
    }
    
    private var _roundTime: Int = 0 {
        didSet {
            totalWorkoutTime.onNext(string(of: TimeInterval(totalTime)))
        }
    }
    private var _restTime: Int = 0 {
        didSet {
            totalWorkoutTime.onNext(string(of: TimeInterval(totalTime)))
        }
    }
    private var _sets: Int = 1 {
        didSet {
            totalWorkoutTime.onNext(string(of: TimeInterval(totalTime)))
        }
    }
    private var _laps: Int = 1 {
        didSet {
            totalWorkoutTime.onNext(string(of: TimeInterval(totalTime)))
        }
    }
    
    private var totalTime: Int {
        (_roundTime + _restTime) * (_sets * _laps)
    }
    
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
    
    func toSeconds(minutes: Int, seconds: Int) -> Int {
        return 60 * minutes + seconds
    }
}

struct Workout {
    var laps: Int
    var rounds: Int
    var roundTime: Int
    var restTime: Int
}
