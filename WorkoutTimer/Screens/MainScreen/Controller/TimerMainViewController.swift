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
    @IBOutlet weak var roundProgressLabel: UILabel!
    @IBOutlet weak var lapProgressLabel: UILabel!
    @IBOutlet weak var flowControlButton: UIButton!
    
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
        
    func configureLabels(for state: WorkoutState) {
        if case let WorkoutState.inProgress(phase) = state {
            timeLabel.text = String(phase.0.timestamp)
            roundProgressLabel.text = "Round: " + String(phase.1.currentRound) + "/" + String(phase.1.total)
            lapProgressLabel.text = "Lap: " + String(phase.2.currentLap) + "/" + String(phase.2.total)
        }
    }
    
    func setFlowControlButtonImage(for state: WorkoutState) {
        switch state {
        case .paused:
            self.flowControlButton.setImage(
                UIImage(named: "button-play"),
                for: .normal)
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
        case .inProgress(let phase):
            switch phase.0 {
            case .action: view.backgroundColor = ColorPalette.running.color
            case .rest: view.backgroundColor = ColorPalette.rest.color
            }
        default: break
        }
    }
}
