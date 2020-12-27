//
//  TimerMainViewModel.swift
//  WorkoutTimer
//
//  Created by Levchuk Misha on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation
import RxSwift

protocol TimerMainViewModelInputs {
    func stopTimer()
    func runTimer()
    func pauseTimer()
}

protocol TimerMainViewModelOutputs {
    var state: PublishSubject<WorkoutState> { get }
}

protocol TimerMainViewModelType {
    var inputs: TimerMainViewModelInputs { get }
    var outputs: TimerMainViewModelOutputs { get}
}

class TimerMainViewModel: TimerMainViewModelType,
                          TimerMainViewModelInputs,
                          TimerMainViewModelOutputs {
    
    let state: PublishSubject<WorkoutState> = PublishSubject()
    
    init(workout: Workout, player: SoundPlayable, configurator: WorkoutConfigurator) {
        self.player = player
        self.configurator = configurator
        self.workout = workout
        self.workoutFlow = configurator.configure(workout)
        runTimer()
    }
    
    func runTimer() {
        disposable = timer
            .takeWhile { _ in self.isTimeRemaining }
            .map { _ in self.phase }
            .subscribe(onNext: { phase in
                self.makeSound(for: phase.value)
                self.state.onNext(.inProgress(phase))
                self.publishWorkoutProgress(for: phase)
            }, onCompleted: {
                self.state.onNext(.finished)
            })
    }
    
    func pauseTimer() {
        state.onNext(.paused)
        disposable?.dispose()
    }
    
    func stopTimer() {
        disposable?.dispose()
        state.onNext(.finished)
    }
    
    private var workoutFlow: [WorkoutPhase] = []
    private var player: SoundPlayable
    private let configurator: WorkoutConfigurator
    private let workout: Workout
    
    private var currentRound = 0
    private var currentLap = 1
    private var disposable: Disposable?
    private var isTimeRemaining: Bool { !workoutFlow.isEmpty }
    private var phase: WorkoutPhase { workoutFlow.removeLast() }
    private let timer = Observable<Int>.interval(
        RxTimeInterval.seconds(1),
        scheduler: MainScheduler.instance)
    
    var inputs: TimerMainViewModelInputs { return self }
    var outputs: TimerMainViewModelOutputs { return self }
}

private extension TimerMainViewModel {
    func makeSound(for time: Int) {
        switch time {
        case 4...:
            player.playSound(of: .tick)
        case 0...3:
            player.playSound(of: .deepTick)
        default:
            break
        }
    }
    func publishWorkoutProgress(for phase: WorkoutPhase) {
        if case let WorkoutPhase.action(timestamp) = phase {
            if timestamp == workout.roundTime {
                if currentRound == workout.rounds {
                    currentRound = 0
                    currentLap += 1
                }
                currentRound += 1
            }
        }
        
        
    }
}


