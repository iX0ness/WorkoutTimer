//
//  ViewController.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 14/08/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import UIKit
import RxSwift

class TimerMainViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        configureActionsAndRests(laps: 2, rounds: 2, roundTime: 2, restTime: 1)
            .subscribe { time in
                print("time: \(time)")
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }.disposed(by: disposeBag)

    }
    
    func runTimer(with time: Int) -> Observable<Int> {
        return Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { time - $0 }
            .takeUntil(.inclusive, predicate: { $0 == 0 })
    }

    
    func configureActionsAndRests(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> Observable<Int> {
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
    
    func createPairedActionRestLap(rounds: Int, roundTime: Int, restTime: Int) -> [Observable<Int>] {
        return (0..<rounds)
            .map { _ in return [runTimer(with: roundTime), runTimer(with: restTime)] }
            .flatMap { $0 }
    }
    
    func createMultiLapWorkoutConfig(laps: Int, rounds: Int, roundTime: Int, restTime: Int) -> [Observable<Int>] {
        return (0..<laps)
            .map { _ in return createPairedActionRestLap(rounds: rounds, roundTime: roundTime, restTime: restTime) }
            .flatMap { $0 }
    }
}

