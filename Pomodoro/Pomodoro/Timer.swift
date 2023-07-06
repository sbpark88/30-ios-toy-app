//
//  Timer.swift
//  Pomodoro
//
//  Created by 박새별 on 2023/07/05.
//

import Foundation
import AudioToolbox

final class Timer {
    
    typealias TimerEventHandler = (Int, Int) -> ()
    typealias TimerStatusChangeHandler = (TimerStatus) -> ()
    
    private let AN_HOUR_SECONDS = 3600
    private let A_MINUTE_SECONDS = 60
    private let TIMER_END_ALARM_SOUND: SystemSoundID = 1005
    
    private var countDownSeconds: Int
    private var remainTime: Int
    private var timerStatus: TimerStatus = .end
    private var timer: DispatchSourceTimer?
    
    init?(countDownSeconds: Int) {
        guard countDownSeconds > 0 else { return nil }
        self.countDownSeconds = countDownSeconds
        self.remainTime = countDownSeconds
    }
    
    func startTimer(timerEventHandler: @escaping TimerEventHandler,
                    timerDidEnd: @escaping TimerStatusChangeHandler) -> TimerStatus? {
        guard countDownSeconds > 0, timer == nil else { return nil }
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1) // interval: 1 second
        timer?.setEventHandler(handler: timerHandler)
        timer?.resume()
        timerStatus = .start
        return timerStatus
        
        func timerHandler() {
            remainTime -= 1
            timerEventHandler(remainTime, countDownSeconds)
            if remainTime <= 0 {
                stopTimer(timerDidEnd: timerDidEnd)
                AudioServicesPlayAlertSound(TIMER_END_ALARM_SOUND)
            }
        }
    }
    
    func pauseTimer(timerDidPause: TimerStatusChangeHandler) {
        timer?.suspend()
        timerStatus = .pause
        timerDidPause(timerStatus)
    }
    
    func resumeTimer(timerDidResume: TimerStatusChangeHandler) {
        timer?.resume()
        timerStatus = .start
        timerDidResume(timerStatus)
    }
    
    func stopTimer(timerDidEnd: TimerStatusChangeHandler) {
        if timerStatus == .pause {
            timer?.resume()
        }
        timer?.cancel()
        timer = nil
        timerStatus = .end
        timerDidEnd(timerStatus)
    }
}

// MARK: Utils
extension Timer {
    func remainTimeDigitalClockFormat(seconds: Int) -> String? {
        guard seconds >= 0 else { return nil }
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func decreasingPorgressRatio(numerator: Int, denominator: Int) -> Float? {
        guard denominator != 0 else { return nil }
        return Float(numerator) / Float(denominator)
    }
}

// MARK: Protocol
protocol SimpleTimer {
    var timerStatus: TimerStatus { get set }
    mutating func timerEventHandler(remainSeconds: Int, totalSeconds: Int)
    mutating func timerDidPause(timerStatus: TimerStatus)
    mutating func timerDidResume(timerStatus: TimerStatus)
    mutating func timerDidEnd(timerStatus: TimerStatus)
}
