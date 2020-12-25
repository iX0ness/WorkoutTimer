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
        self.workout = configurator.configureWorkout(
            laps: workout.laps,
            rounds: workout.rounds,
            roundTime: workout.roundTime,
            restTime: workout.restTime)
        runTimer()
    }
        
    func runTimer() {
        disposable = timer
            .takeWhile { _ in self.isTimeRemaining }
            .map { _ in self.phase }
            .subscribe(onNext: { phase in
                self.makeSound(for: phase.value)
                self.state.onNext(.inProgress(phase))
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
    
    private var disposable: Disposable?
    private var isTimeRemaining: Bool { !workout.isEmpty }
    private var phase: WorkoutPhase { workout.removeLast() }
    private var workout: [WorkoutPhase] = []
    private var player: SoundPlayable
    private let configurator: WorkoutConfigurator
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
}


