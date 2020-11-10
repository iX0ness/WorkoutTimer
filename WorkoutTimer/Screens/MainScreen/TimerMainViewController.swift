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
    var subscription: Disposable?
    let disposeBag = DisposeBag()
    
    var time = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        subscription = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { self.time - $0 }
            .takeUntil(.inclusive, predicate: { $0 == 0 })
            .subscribe(onNext: { value in
                print(value)
            }, onCompleted: {
                print("completed")
            })
        subscription?.disposed(by: disposeBag)
    }

}

