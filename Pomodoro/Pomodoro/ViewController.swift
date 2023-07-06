//
//  ViewController.swift
//  Pomodoro
//
//  Created by 박새별 on 2023/07/04.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tomato: UIImageView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var countDownSeconds: Int?
    var timerStatus: TimerStatus = .end
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        if timerStatus == .end { return }
        let status = timer?.stopTimer(timerDidEnd: timerDidEnd)
        if let status {
            timerStatus = status
            changeUiSettingMode()
            changeConfirmButtonSettingMode()
        }
    }
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        countDownSeconds = Int(datePicker.countDownDuration)
        guard let countDownSeconds else { return }
        
        switch timerStatus {
        case .start:
            pauseTimer()
        case .pause:
            resumeTimer()
        case .end:
            startTimer(countDownSeconds: countDownSeconds)
        }
    }
    
    private func startTimer(countDownSeconds: Int) {
        timer = Timer(countDownSeconds: countDownSeconds)
        let status = timer?.startTimer(timerEventHandler: timerEventHandler(remainSeconds:totalSeconds:), timerDidEnd: timerDidEnd)
        if let status {
            timerStatus = status
        }
    }
    
    private func pauseTimer() {
        let status = timer?.pauseTimer(timerDidPause: timerDidPause)
        if let status {
            timerStatus = status
        }
    }
    
    private func resumeTimer() {
        let status = timer?.resumeTimer(timerDidResume: timerDidResume)
        if let status {
            timerStatus = status
        }
    }
    
    private func endTimer() {
        let status = timer?.stopTimer(timerDidEnd: timerDidEnd)
        if let status {
            timerStatus = status
        }
    }
}

// MARK: Adopt SimpleTimer Protocol
extension ViewController: SimpleTimer {
    
    func timerEventHandler(remainSeconds: Int, totalSeconds: Int) {
        guard let timeString = timer?.remainTimeDigitalClockFormat(seconds: remainSeconds),
              let timeRatio = timer?.decreasingPorgressRatio(numerator: remainSeconds, denominator: totalSeconds)
        else { return }
        timerLabel.text = timeString
        progressBar.progress = timeRatio
        changeUiRunningMode()
        rotateTomato()
    }
    
    func timerDidPause() {
        changeConfirmButtonPauseMode()
    }
    
    func timerDidResume() {
        changeConfirmButtonResumeMode()
    }
    
    func timerDidEnd() {
        changeConfirmButtonSettingMode()
    }
    
}

// MARK: Config
extension ViewController {
    func configureToggleButton() {
        self.confirmButton.setTitle("시작", for: .normal)
        self.confirmButton.setTitle("일시정지", for: .selected)
    }
}

// MARK: UI
extension ViewController {
    // main
    func changeUiSettingMode() {
        UIView.animate(withDuration: 0.5) {
            self.timerLabel.alpha = 0
            self.progressBar.alpha = 0
            self.datePicker.alpha = 1
        }
        confirmButton.isSelected = false
        cancelButton.isEnabled = false
    }
    
    func changeUiRunningMode() {
        UIView.animate(withDuration: 0.5) {
            self.timerLabel.alpha = 1
            self.progressBar.alpha = 1
            self.datePicker.alpha = 0
        }
        confirmButton.isSelected = true
        cancelButton.isEnabled = true
    }
    
    // confirm button
    func changeConfirmButtonSettingMode() {
        confirmButton.isSelected = false
        confirmButton.setTitle("시작", for: .normal)
    }
    
    func changeConfirmButtonPauseMode() {
        confirmButton.isSelected = false
        confirmButton.setTitle("재개", for: .normal)
    }
    
    func changeConfirmButtonResumeMode() {
        confirmButton.isSelected = true
    }
    
    // tomato
    func rotateTomato() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.tomato.transform = CGAffineTransform(rotationAngle: .pi)
        }
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.tomato.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }
    }
    
    func stopTomato() {
        UIView.animate(withDuration: 0.5) {
            self.tomato.transform = .identity
        }
    }
}
