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
        print("Deinitialized Main")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.running.color
        setupTimeView()
        bindState()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func controllWorkoutFlow(_ sender: UIButton) {
        switch state {
        case .paused:
            viewModel?.inputs.runTimer()
        case .inProgress:
            viewModel?.inputs.pauseTimer()
        default:
            break
        }
    }
    
    @IBAction func stopWorkout(_ sender: UIButton) {
        viewModel?.inputs.stopTimer()
        
    }
    
    private var disposeBag = DisposeBag()
    private var timerSubscription: Disposable?
    private var state: WorkoutState?
}

private extension TimerMainViewController {
    func setupTimeView() {
        timeView.backgroundColor = ColorPalette.subprimary.color
        timeView.clipsToBounds = true
        timeView.layer.cornerRadius = timeView.frame.width / 2
        timeLabel.textColor = ColorPalette.primary.color
    }
    
    func bindState() {
        viewModel?.outputs.state.subscribe(onNext: { [weak self] state in
            self?.state = state
            self?.setFlowControlButtonImage(for: state)
            self?.setBackgroundColor(for: state)
            self?.configureLabels(for: state)
            if case WorkoutState.finished = state {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
//    func bindState() {
//                viewModel?.outputs.workoutState.subscribe(onNext: { [weak self] state in
//                    self?.setFlowControlButtonImage(for: state)
//                    switch state {
//                    case .paused:
//                        self?.timerSubscription?.dispose()
//                    case .running:
//                        self?.runTimer()
//                    }
//                }).disposed(by: disposeBag)
//    }
    
    //    func runTimer() {
    //        guard let viewModel = viewModel else { return }
    //        timerSubscription = viewModel.outputs.timer
    //            .takeWhile { _ in viewModel.outputs.isWorkoutCompleted }
    //            .map { _ in viewModel.outputs.phase }
    //            .subscribe(onNext: { phase in
    //                viewModel.inputs.makeSound(for: phase.value)
    //                self.setBackgroundColor(for: phase)
    //                self.timeLabel.text = String(phase.value)
    //            }, onCompleted: {
    //                self.navigationController?.popViewController(animated: true)
    //            }, onDisposed: {
    //                self.view.backgroundColor = ColorPalette.pause.color
    //            })
    //    }
    
    func configureLabels(for state: WorkoutState) {
        if case let WorkoutState.inProgress(phase) = state {
            self.timeLabel.text = String(phase.value)
        }
    }
    
    func setFlowControlButtonImage(for state: WorkoutState) {
        switch state {
        case .paused:
            self.flowControlButton.setImage(
                UIImage(named: "button-play"),
                for: .normal
            )
        case .inProgress:
            self.flowControlButton.setImage(
                UIImage(named: "button-pause"),
                for: .normal)
            
        default:
            break
        }
    }
    
    func setBackgroundColor(for state: WorkoutState) {
        switch state {
        case .paused: view.backgroundColor = ColorPalette.pause.color
        case .inProgress(let phase):
            switch phase {
            case .action: view.backgroundColor = ColorPalette.running.color
            case .rest: view.backgroundColor = ColorPalette.rest.color
            }
        default: break
            
        }
    }
    
    
}


