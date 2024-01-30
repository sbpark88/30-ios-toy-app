//
//  AlertManager.swift
//  DrinkWater
//
//  Created by 박새별 on 1/30/24.
//

import Foundation

protocol AlertManagerDelegate {
    func alertManager(_ manager: AlertManager, didUpdateAlert: Bool)
//    func alertManager(_ manager: AlertManager, didUpdateAlert: [Alert])
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
    
    func save(alerts: [Alert], sort: Bool = true) {
        save(alerts: alerts.sorted { $0.date < $1.date })
    }
    
    private func save(alerts: [Alert]) {
        do {
            try DataUtil().toUserDefaults(alerts, forkey: ALERT_KEY)
            notify()
        } catch {
            delegate?.alertManager(self, didFaillWithError: error)
        }
    }
        
    func delete(id: String)  {
        save(alerts: load().filter { $0.id != id })
        notify()
    }
    
    private func notify() {
        delegate?.alertManager(self, didUpdateAlert: true)
    }
    
}
