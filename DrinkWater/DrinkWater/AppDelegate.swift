//
//  AppDelegate.swift
//  DrinkWater
//
//  Created by 박새별 on 1/29/24.
//

import UIKit
import NotificationCenter
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 앱이 foreground 일 때 알림 허용을 위해 delegate 위임
        UNUserNotificationCenter.current().delegate = self
        
        requestNotificationAuthorization()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

/*
`UNUserNotificationCenter`와 `NotificationCenter`는 모두 알림 및 이벤트를 관리하는 데 사용되는 클래스입니다. 그러나 두 클래스 간에는 몇 가지 중요한 차이점이 있습니다.

1. **범위:**
   - `UNUserNotificationCenter`: iOS 10부터 도입된 클래스로, 알림의 스케줄링 및 관리에 사용됩니다. 주로 사용자에게 알림을 보내는 데 사용됩니다. `UNUserNotificationCenter`를 사용하면 시스템에서 관리하는 노티피케이션을 생성하고 예약할 수 있습니다.
   - `NotificationCenter`: iOS 2부터 도입된 클래스로, 애플리케이션 내에서 발생하는 이벤트를 관리하는 데 사용됩니다. 이벤트는 `post`, `addObserver` 및 `removeObserver` 메서드를 사용하여 다른 객체에 전달됩니다. 사용자 정의 이벤트를 처리하는 데 사용됩니다.

2. **사용 방식:**
   - `UNUserNotificationCenter`: 주로 시스템에서 발생하는 알림 및 이벤트를 처리하는 데 사용됩니다. 예를 들어, 사용자가 앱을 실행하지 않는 동안 예약된 알림을 관리하고 처리하는 데 사용됩니다.
   - `NotificationCenter`: 애플리케이션 내에서 사용자 지정 이벤트를 처리하는 데 사용됩니다. 예를 들어, 특정 작업이 완료될 때마다 다른 객체에게 이벤트를 알리거나 통신하기 위해 사용됩니다.

3. **iOS 버전 지원:**
   - `UNUserNotificationCenter`: iOS 10 이상에서 사용 가능합니다.
   - `NotificationCenter`: iOS 2 이상에서 사용 가능합니다.

요약하면, `UNUserNotificationCenter`는 iOS에서 알림 관리를 위해 사용되는 전용 클래스이고, `NotificationCenter`는 애플리케이션 내의 이벤트 처리를 위한 일반적인 클래스입니다.
*/

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: authOptions) { granted, error in
                if let error {
                    print("Error: notification authrization request fail \(error.localizedDescription)")
                }
            }
    }
    
    // 앱이 foreground 일 때 push 를 받기 위한 메서드(`delegate`를 반드시 지정해야한다).
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
        print("willPresent")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        print("didReceive")
    }
        
}
