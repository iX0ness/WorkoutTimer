//
//  TimerMainViewModel.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation

protocol TimerMainViewModelInputs {
    func makeSound()
    func changeState()
}

protocol TimerMainViewModelOutputs {
    var timer: Observable<Int> { get }
    var workoutState: BehaviorSubject<WorkoutState> { get }
    var isTimeRemaining: Bool { get }
    var time: Int { get }
}

protocol TimerMainViewModelType {
    var inputs: TimerMainViewModelInputs { get }
    var outputs: TimerMainViewModelOutputs { get}
}

class TimerMainViewModel: TimerMainViewModelType, TimerMainViewModelInputs, TimerMainViewModelOutputs {
    
    let workoutState: BehaviorSubject<WorkoutState> = BehaviorSubject(value: .running)
    let timer = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    var isTimeRemaining: Bool { !workout.isEmpty }
    var time: Int { workout.removeLast() }
    
    init(workout: Workout) {
        self.workout = configureWorkout(
            laps: workout.laps,
            rounds: workout.rounds,
            roundTime: Int(workout.roundTime),
            restTime: Int(workout.restTime))
    }
    
    func makeSound() {
        produceTickSound()
    }
    
    func changeState() {
        guard let state = try? workoutState.value() else {
            fatalError("Workout must have some entry state")
        }
        
        switch state {
        case .paused:
            self.workoutState.onNext(.running)
        case .running:
            self.workoutState.onNext(.paused)
        }
    }
    
    private var workout: [Int] = []
    private var soundPlayer: AVAudioPlayer?
    
    var inputs: TimerMainViewModelInputs { return self }
    var outputs: TimerMainViewModelOutputs { return self }
}


private extension TimerMainViewModel {
    func produceTickSound() {
        let path = Bundle.main.path(forResource: "tick.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
        } catch {
            print("Couldn't load file")
        }
    }
}

// MARK: - Workout Configurations

extension TimerMainViewModel {
    func set(roundTime: Int, restTime: Int) -> [[Int]] {
        return [(0...roundTime).map { $0 }, (0...restTime).map { $0 }]
    }
    
    func multiRoundSet(rounds: Int, roundTime: Int, restTime: Int) -> [[Int]] {
        return (0...rounds)
            .map { _ in set(roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
    }
    
    func multiLapSet(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [[Int]] {
        return (0...laps)
            .map { _ in multiRoundSet(rounds: rounds, roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
    }
    
    func configureWorkout(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [Int] {
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


