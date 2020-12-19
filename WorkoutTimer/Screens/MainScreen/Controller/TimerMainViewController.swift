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
        disposable?.dispose()
        navigationController?.popViewController(animated: true)
    }
    
    private var disposeBag = DisposeBag()
    private var disposable: Disposable?
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
            switch state {
            case .paused:
                self?.view.backgroundColor = Colors.red
                self?.setFlowControlButtonImage(for: state)
                self?.disposable?.dispose()
            case .running:
                self?.view.backgroundColor = Colors.green
                self?.setFlowControlButtonImage(for: state)
                self?.runTimer()
            }
        }).disposed(by: disposeBag)
    }
    
    func runTimer() {
        guard let viewModel = viewModel else { return }
        disposable = viewModel.outputs.timer
            .takeWhile { _ in viewModel.outputs.isTimeRemaining }
            .map { _ in viewModel.outputs.time }
            .subscribe(onNext: { time in
                viewModel.inputs.makeSound()
                self.timeLabel.text = String(time)
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
    
    enum Colors {
        static let green = UIColor(hexString: "1BBC9B")
        static let red = UIColor(hexString: "E64C66")
    }
}


