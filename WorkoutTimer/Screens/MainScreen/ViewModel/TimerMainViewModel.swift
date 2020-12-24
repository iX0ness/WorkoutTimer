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
    func makeSound(for time: Int)
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
    
    
    var state: PublishSubject<WorkoutState> = PublishSubject()
    var isWorkoutCompleted: Bool { !workout.isEmpty }
    var phase: WorkoutPhase { workout.removeLast() }
    
    init(workout: Workout, player: SoundPlayable, configurator: WorkoutConfigurator.Type) {
        self.player = player
        self.workout = configurator.configureWorkout(
            laps: workout.laps,
            rounds: workout.rounds,
            roundTime: workout.roundTime,
            restTime: workout.restTime)
        print(self.workout)
        runTimer()
        
    }
    
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
    
    func runTimer() {
        disposable = timer
            .takeWhile { _ in !self.workout.isEmpty }
            .map { _ in self.phase }
            .subscribe(onNext: { phase in
                self.state.onNext(.inProgress(phase))
            }, onCompleted: {
                self.state.onNext(.finished)
            }, onDisposed: {
                print("Disposed")
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
    private let timer = Observable<Int>
        .interval(RxTimeInterval.seconds(1),
                  scheduler: MainScheduler.instance)
    private var workout: [WorkoutPhase] = []
    private var player: SoundPlayable
    
    var inputs: TimerMainViewModelInputs { return self }
    var outputs: TimerMainViewModelOutputs { return self }
}


