//
//  NotificationManager.swift
//  DrinkWater
//
//  Created by 박새별 on 1/30/24.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    func scheduleNotification(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요💦"
        content.body = "WHO 가 권장되는 하루 물 섭취량은 "
        content.sound = .default
        content.badge = (Int(truncating: content.badge ?? 0) + 1) as NSNumber
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .timeZone], from: alert.date)
        
        // 알림이 트리거될 조건 설정
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        // UNUserNotificationCenter에 알림 요청 등록
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Schedule alert success.")
            }
        }
    }
    
    func cancelNotification(by alert: Alert) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alert.id])
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiers = requests.map { $0.identifier }
            print("Activated alerts are \(identifiers)")
            if identifiers.contains(alert.id) {
                print("Error: \(alert.id) alarm is not removed.")
            } else {
                print("Remove alert success.")
            }
        }
    }
    
}
