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
    var viewModel: TimerMainViewModelType?
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupTimeView()
//        let zalupa = viewModel?.outputs.workoutTimeFlow
//            .map { String($0) }
//            .share()
//        
//        zalupa?.bind(to: timeLabel.rx.text)
//        .disposed(by: disposeBag)
//        
//        guard let z = zalupa else { return }
//        z.subscribe(onDisposed: {
//            self.navigationController?.popViewController(animated: true)
//        }).disposed(by: disposeBag)
////            .bind(to: timeLabel.rx.text)
////            .disposed(by: disposeBag)
    }
    
    deinit {
        print("deinitialized")
    }
    
    @IBAction func controllWorkoutFlow(_ sender: UIButton) {
        viewModel?.inputs.pause()
    }
    @IBAction func stopWorkout(_ sender: UIButton) {
        viewModel?.inputs.cancel()
    }
    func setupTimeView() {
        timeView.backgroundColor = ColorPalette.subprimary.color
        timeView.clipsToBounds = true
        timeView.layer.cornerRadius = 10
        timeLabel.textColor = ColorPalette.primary.color
        
    }
}

