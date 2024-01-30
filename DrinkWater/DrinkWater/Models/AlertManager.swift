//
//  AlertManager.swift
//  DrinkWater
//
//  Created by 박새별 on 1/30/24.
//

import Foundation
import UserNotifications

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
    
    // 신규 Alert
    func save(alert: Alert) {
        var alerts = load()
        alerts.append(alert)
        let uniqueAlerts = removeDuplicate(alerts: alerts)
        
        // 중복이 없을 때만 저장
        guard uniqueAlerts.count == alerts.count else { return }
        let sortedAlerts = uniqueAlerts
            .map(createAlertTime(alert:))
            .sorted { todayMinutes(of: $0.date) < todayMinutes(of: $1.date) }

        save(alerts: sortedAlerts)
        alertOn(by: alert)
    }
    
    private func todayMinutes(of date: Date) -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        return dateComponents.hour! * 60 + dateComponents.minute!
    }
    
    // UserDefaults 에 저장
    private func save(alerts: [Alert]) {
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
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: alert.date)
        
        /*
         calendar.date(from: dateComponents)! 에 의해 date 값을 print로 출력해보면
         "0001-01-01 08:28:08 +0000"와 같이 나온다.
         
         하지만 LLDB 를 이용해 p 명령으로 출력해보면
         "date = 0000-12-30 08:27:08 UTC"
         po 명령으로 출력해보면
         "date : 0001-01-01 08:27:08 +0000
         - timeIntervalSinceReferenceDate : -63114046372.0"
         timestamp 값으로 저장하고 실제 우리한테 보여줄 때는 Computed Properties 를 사용하는 듯 하다.
         실제로는 정상 값이 출력되니 print 에 나오는 시간은 무시하자.
         */
        return Alert(id: alert.id,
                     date: calendar.date(from: dateComponents)!,
                     isOn: alert.isOn)
    }
    
    func update(alert: Alert) {
        save(alerts: load().map { $0.id == alert.id
            ? Alert(id: alert.id,
                    date: alert.date,
                    isOn: !alert.isOn)
            : $0 })
        
        // 현재 on 이면 off, off 면 on 해야한다.
        alert.isOn ? alertOff(by: alert) : alertOn(by: alert)
    }
    
    func delete(alert: Alert)  {
        save(alerts: load().filter { $0.id != alert.id })
        alertOff(by: alert)
        notify()
    }
    
    private func notify() {
        delegate?.alertManager(self, didUpdateAlert: true)
    }
    
    private func alertOn(by alert: Alert) {
        print("Alert On \(alert.id)")
        NotificationManager().scheduleNotification(by: alert)
    }
    
    private func alertOff(by alert: Alert) {
        print("Alert Off \(alert.id)")
        NotificationManager().cancelNotification(by: alert)
    }
    
}
