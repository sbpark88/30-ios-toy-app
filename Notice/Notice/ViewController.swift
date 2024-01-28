//
//  ViewController.swift
//  Notice
//
//  Created by 박새별 on 1/27/24.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRemoteConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotice()
    }
    
    private func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
}

// FirebaseRemoteConfig
extension ViewController {
    func getNotice() {
        guard let remoteConfig else { return }
        remoteConfig.fetch { [unowned self] status, error in
            if status == .success {
                remoteConfig.activate()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
            if isNoticeHidden(remoteConfig) {
                let noticeViewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                
                noticeViewController.modalPresentationStyle = .custom
                noticeViewController.modalTransitionStyle = .crossDissolve
                
                let (title, detail, date) = (
                    remoteConfig["title"].stringValue ?? "",
                    remoteConfig["detail"].stringValue ?? "",
                    remoteConfig["date"].stringValue ?? ""
                )
                
                print(title)
                
                noticeViewController.noticeContents = (title, detail, date)
                present(noticeViewController, animated: true)
            }
            
        }
    }
    
    private func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        remoteConfig["isHidden"].boolValue
    }
    
}
