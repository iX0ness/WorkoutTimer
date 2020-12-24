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
        view.backgroundColor = .yellow
        setupTimeView()
        bindState()
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func controllWorkoutFlow(_ sender: UIButton) {
        viewModel?.inputs.changeState()
    }
    
    @IBAction func stopWorkout(_ sender: UIButton) {
        timerSubscription?.dispose()
        navigationController?.popViewController(animated: true)
    }
    
    private var disposeBag = DisposeBag()
    private var timerSubscription: Disposable?
}

private extension TimerMainViewController {
    func setupTimeView() {
        timeView.backgroundColor = ColorPalette.subprimary.color
        timeView.clipsToBounds = true
        timeView.layer.cornerRadius = timeView.frame.width / 2
        timeLabel.textColor = ColorPalette.primary.color
    }
    
    func bindState() {
        viewModel?.outputs.workoutState.subscribe(onNext: { [weak self] state in
            self?.setFlowControlButtonImage(for: state)
            switch state {
            case .paused:
                self?.view.backgroundColor = ColorPalette.pause.color
                
                self?.timerSubscription?.dispose()
            case .running:
                self?.view.backgroundColor = ColorPalette.running.color
                self?.runTimer()
            }
        }).disposed(by: disposeBag)
    }
    
    func runTimer() {
        guard let viewModel = viewModel else { return }
        timerSubscription = viewModel.outputs.timer
            .takeWhile { _ in viewModel.outputs.isWorkoutCompleted }
            .map { _ in viewModel.outputs.phase }
            .subscribe(onNext: { phase in
                
                viewModel.inputs.makeSound(for: phase.value)
                self.timeLabel.text = String(phase.value)
            }, onCompleted: {
                self.navigationController?.popViewController(animated: true)
            })
    }
    
    func setFlowControlButtonImage(for state: WorkoutState) {
        switch state {
        case .paused:
            self.flowControlButton.setImage(
                UIImage(named: "button-play"),
                for: .normal
            )
        case .running:
            self.flowControlButton.setImage(
                UIImage(named: "button-pause"),
                for: .normal)
        }
    }
}


