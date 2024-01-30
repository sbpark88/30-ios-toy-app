//
//  AlertManager.swift
//  DrinkWater
//
//  Created by 박새별 on 1/30/24.
//

import Foundation

protocol AlertManagerDelegate {
    func alertManager(_ manager: AlertManager, didUpdateAlert: Bool)
    func alertManager(_ manager: AlertManager, didFaillWithError error: Error?)
}


struct AlertManager {
    
    let ALERT_TYPE = [Alert].self
    let ALERT_KEY = "alerts"
    
    var delegate: AlertManagerDelegate?
    
    func load() -> [Alert] {
        let alerts = try? DataUtil().fromUserDefaults(ALERT_TYPE, forkey: ALERT_KEY)
        return alerts == nil ? [] : alerts!
    }
    
    func save(alerts: [Alert]) {
        let uniqueAlerts = removeDuplicate(alerts: alerts)
        
        // 중복이 없을 때만 저장
        guard uniqueAlerts.count == alerts.count else { return }
        let sortedAlerts = uniqueAlerts
            .sorted { todayMinutes(of: $0.date) < todayMinutes(of: $1.date) }

        saveToUserDefaults(alerts: sortedAlerts)
    }
    
    private func todayMinutes(of date: Date) -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        return dateComponents.hour! * 60 + dateComponents.minute!
    }
    
    private func saveToUserDefaults(alerts: [Alert]) {
        do {
            try DataUtil().toUserDefaults(alerts, forkey: ALERT_KEY)
            notify()
        } catch {
            delegate?.alertManager(self, didFaillWithError: error)
        }
    }
    
    private func removeDuplicate(alerts: [Alert]) -> [Alert] {
        // 년, 월, 일 정보 때문에 Set 으로 제거 불가능
        var uniqueTimes: [String] = []
        var uniqueAlerts: [Alert] = []
        for alert in alerts {
            if !uniqueTimes.contains(alert.time) {
                uniqueTimes.append(alert.time)
                uniqueAlerts.append(alert)
            }
        }
        return uniqueAlerts
    }
    
    private func createAlertTime(alert: Alert) -> Alert {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .month, .minute], from: alert.date)
        dateComponents.second = 0
        
        return Alert(id: alert.id,
                     date: calendar.date(from: dateComponents)!,
                     isOn: alert.isOn)
    }
        
    func delete(id: String)  {
        saveToUserDefaults(alerts: load().filter { $0.id != id })
        notify()
    }
    
    private func notify() {
        delegate?.alertManager(self, didUpdateAlert: true)
    }
    
}
