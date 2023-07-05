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
    var timer: DispatchSourceTimer?
    var remainTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    func startTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            timer?.schedule(deadline: .now(), repeating: 1)
            timer?.setEventHandler(handler: { [weak self] in
                guard let remainTime = self?.remainTime,
                      let countDownSeconds = self?.countDownSeconds else { self?.stopTimer();return }
                self?.remainTime -= 1
                
                let hours = remainTime / 3600
                let minutes = (remainTime % 3600) / 60
                let seconds = (remainTime % 3600) % 60
                
                self?.timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                self?.progressBar.progress = Float(remainTime) / Float(countDownSeconds)
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self?.tomato.transform = CGAffineTransform(rotationAngle: .pi)
                }
                UIView.animate(withDuration: 0.5, delay: 0.5) {
                    self?.tomato.transform = CGAffineTransform(rotationAngle: .pi * 2)
                }
                
                if remainTime <= 0 {
                    self?.stopTimer()
                    AudioServicesPlayAlertSound(1005)
                }
            })
            timer?.resume()
        }
    }
    
    func stopTimer() {
        if timerStatus == .pause {
            timer?.resume()
        }
        timerStatus = .end
        cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.timerLabel.alpha = 0
            self.progressBar.alpha = 0
            self.datePicker.alpha = 1
            self.tomato.transform = .identity
        }
        confirmButton.isSelected = false
        timer?.cancel()
        timer = nil
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
            
        case .start, .pause:
            stopTimer()
        default:
            break
        }
    }
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        countDownSeconds = Int(datePicker.countDownDuration)
        guard let countDownSeconds else { return }
        
        switch timerStatus {
        case .end:
            remainTime = countDownSeconds
            timerStatus = .start
            UIView.animate(withDuration: 0.5) {
                self.timerLabel.alpha = 1
                self.progressBar.alpha = 1
                self.datePicker.alpha = 0
            }
            confirmButton.isSelected = true
            cancelButton.isEnabled = true
            startTimer()
        case .start:
            timerStatus = .pause
            confirmButton.isSelected = false
            timer?.suspend()
        case .pause:
            timerStatus = .start
            confirmButton.isSelected = true
            timer?.resume()
        }
    }
}

// MARK: Config
extension ViewController {
    func configureToggleButton() {
        self.confirmButton.setTitle("시작", for: .normal)
        self.confirmButton.setTitle("일시정지", for: .selected)
    }
}
