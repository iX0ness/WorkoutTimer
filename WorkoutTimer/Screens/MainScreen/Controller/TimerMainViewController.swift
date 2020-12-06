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
    @IBOutlet weak var flowControlButton: UIButton!
    
    deinit {
        print("deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupTimeView()
        //bindViewModel()
        
    }
    
    @IBAction func controllWorkoutFlow(_ sender: UIButton) {
        viewModel?.inputs.changeFlowState()
    }
    
    @IBAction func stopWorkout(_ sender: UIButton) {
        workoutFlowSubscription?.dispose()
        viewModel?.inputs.cancel()
    }
    
    private var workoutFlowSubscription: Disposable?
    private var disposeBag = DisposeBag()
}

private extension TimerMainViewController {
    func setupTimeView() {
        timeView.backgroundColor = ColorPalette.subprimary.color
        timeView.clipsToBounds = true
        timeView.layer.cornerRadius = 10
        timeLabel.textColor = ColorPalette.primary.color
        
    }
    
    func bindViewModel() {
        workoutFlowSubscription = viewModel?.outputs.workoutTimeFlow
            .map { String($0) }
            .bind(to: timeLabel.rx.text)
        
        workoutFlowSubscription = viewModel?.outputs.workoutTimeFlow
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.inputs.makeSound()
            },
            onDisposed: {
                self.navigationController?.popViewController(animated: true)
            })
        
        viewModel?.outputs.workoutState
            .subscribe { [weak self] state in
                self?.setFlowControlButtonImage(for: state)
            }.disposed(by: disposeBag)
    }
    
    func setFlowControlButtonImage(for state: WorkoutState) {
        switch state {
        case .running:
            flowControlButton.setImage(UIImage(named: "play-button"), for: .normal)
            
        case .paused:
            flowControlButton.setImage(UIImage(named: "pause"), for: .normal)
            
        }
    }
    
    
    
}


