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
    var workoutSubscription: Disposable?
    var restSubscription: Disposable?
    let disposeBag = DisposeBag()
    
    var rounds = 3
    var workoutTime = 10
    var restTime = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
//        let workout = runTimer(with: workoutTime, for: "workout time")
//        let rest = runTimer(with: restTime, for: "rest time")
//        Observable.concat([workout, rest]).subscribe { element in
//            print("Element: \(element)")
//        } onCompleted: {
//            print("completed")
//        } onDisposed: {
//            print("Disposed")
//        }.disposed(by: disposeBag)

        configureActionsAndRests(laps: 1, rounds: 2, roundTime: 5, restTime: 3)
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
            let result = (0..<rounds)
                .map { _ in return [runTimer(with: roundTime), runTimer(with: restTime)] }
                .flatMap { $0 }
                .dropLast()
            return Observable.concat(result)
            
            
            
        default:
           return  Observable.of(2)
        }
    
    }
}

