//
//  ViewController.swift
//  Pomodoro
//
//  Created by 박새별 on 2023/07/04.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressBar.isHidden = isHidden
    }
    
    func startTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            timer?.schedule(deadline: .now(), repeating: 1)
            timer?.setEventHandler(handler: { [weak self] in
                self?.remainTime -= 1
                debugPrint(self?.remainTime as Any)
                
                if self?.remainTime ?? 0 <= 0 {
                    self?.stopTimer()
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
        setTimerInfoViewVisible(isHidden: true)
        datePicker.isHidden = false
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
            setTimerInfoViewVisible(isHidden: false)
            datePicker.isHidden = true
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
