//
//  ViewController.swift
//  Notice
//
//  Created by 박새별 on 1/27/24.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig!
    
    var showNotice: Bool { remoteConfig["showNotice"].boolValue }
    var showEvent: Bool { remoteConfig["showEvent"].boolValue }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showServerMessage()
        Analytics.logEvent("Log Start", parameters: nil)
    }
    
    private func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    private func showServerMessage() {
        remoteConfig.fetch { [unowned self] status, error in
            if status == .success {
                remoteConfig.activate()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
            // status success 가 아닐 경우, 기본값에 의해 showNotice true 이므로 접속 에러 공지, event 는 false
            // status success 일 경우, remoteConfig.activate() 에 의해 업데이트 된 showNotice, showEvent 값에 의해 작동
            if showNotice {
                showNoticeAlert()
            } else if showEvent {
                showEventAlert()
            }
        }
    }
    
}

// FirebaseRemoteConfig
extension ViewController {
    func showNoticeAlert() {
        let noticeViewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
        
        noticeViewController.modalPresentationStyle = .custom
        noticeViewController.modalTransitionStyle = .crossDissolve
        
        let (title, detail, date) = (
            remoteConfig["title"].stringValue ?? "",
            remoteConfig["detail"].stringValue ?? "",
            remoteConfig["date"].stringValue ?? ""
        )
        
        noticeViewController.noticeContents = (title, detail, date)
        present(noticeViewController, animated: true)
    }
}

// A/B Testing
extension ViewController {
    private func showEventAlert() {
        let message = remoteConfig["eventMessage"].stringValue ?? ""
        
        // < Modal Header & Body >
        // likes document.createElement()
        let alert = UIAlertController(title: "깜짝 이벤트", message: message, preferredStyle: .alert)

        // < Modal Footer Button >
        let confirmAction = UIAlertAction(title: "확인하기", style: .default) { action in
            // Google Analytics
            // debug view 에 기기가 안 잡히거나 잡혀도 디버그가 안 보이는 경우가 있다.
            // adguard 끄고 웹페이지 새로고침을 하다 보면 잡힘.
            Analytics.logEvent("promotion_alert_ratio", parameters: nil)
            Analytics.logEvent("promotion_alert", parameters: nil)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
