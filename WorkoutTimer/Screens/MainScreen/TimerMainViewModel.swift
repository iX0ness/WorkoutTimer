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
    func pause()
    func cancel()
}
protocol TimerMainViewModelOutputs {
    var workoutTimeFlow: Observable<Int> { get }
}
protocol TimerMainViewModelType {
    var inputs: TimerMainViewModelInputs { get }
    var outputs: TimerMainViewModelOutputs { get}
}

class TimerMainViewModel: TimerMainViewModelType, TimerMainViewModelInputs, TimerMainViewModelOutputs {
    
    

    var workoutTimeFlow: Observable<Int>
    var soundPlayer: AVAudioPlayer?
    let disposeBag = DisposeBag()
    
    init(workout: Workout) {
        workoutTimeFlow = TimerMainViewModel.configureActionsAndRests(
            laps: workout.laps,
            rounds: workout.rounds,
            roundTime: Int(workout.roundTime),
            restTime: Int(workout.restTime)
        )
        timerSubscription = workoutTimeFlow.subscribe(onNext: { [weak self] time in
            self?.produceTickSound()
        }, onDisposed: {
            print("Disposed")
        })
    }
    
    func pause() {
        
    }
    
    func cancel() {
        //workoutTimeF
        timerSubscription?.dispose()
        
    }
    
    private var timerSubscription: Disposable?
    
    
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















// MARK: - Time Observables
private extension TimerMainViewModel {
    static func runTimer(with time: Int) -> Observable<Int> {
        return Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { time - $0 }
            .takeUntil(.inclusive, predicate: { $0 == 0 })
    }
    
    static func configureActionsAndRests(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> Observable<Int> {
        switch (laps, rounds) {
        case (1, 1):
            return runTimer(with: roundTime)
        case (1, 1...):
            let workoutConfig = createPairedActionRestLap(rounds: rounds, roundTime: roundTime, restTime: restTime).dropLast()
            return Observable.concat(workoutConfig)
        case (2, 1...):
            let workoutConfig = createMultiLapWorkoutConfig(laps: laps, rounds: rounds, roundTime: roundTime, restTime: restTime).dropLast()
            return Observable.concat(workoutConfig)
            
        default:
            fatalError(
                """
            Unexpected number of laps or rounds
            Laps: \(laps) | Rounds: \(rounds)
            """)
        }
        
    }
    
    static func createPairedActionRestLap(rounds: Int, roundTime: Int, restTime: Int) -> [Observable<Int>] {
        return (0..<rounds)
            .map { _ in return [runTimer(with: roundTime), runTimer(with: restTime)] }
            .flatMap { $0 }
    }
    
    static func createMultiLapWorkoutConfig(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [Observable<Int>] {
        return (0..<laps)
            .map { _ in return createPairedActionRestLap(rounds: rounds, roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
    }
}
