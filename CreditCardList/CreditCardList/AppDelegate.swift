//
//  AppDelegate.swift
//  CreditCardList
//
//  Created by 박새별 on 1/9/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        createFirestoreCollection(db: db)
        
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

extension AppDelegate {
    
    // dummy 데이터로부터 초기 컬렉션 생성
    private func createFirestoreCollection(db: Firestore?) {
        let COLLECTION_NAME = "creditCardList"
        
        
        guard let db else { return }
        db.collection(COLLECTION_NAME).getDocuments(completion: { snapshot, error in
            guard snapshot?.isEmpty == true else { return }
            let batch = db.batch()
            
            do {
                for (name, data) in CreditCardDummy {
                    let cardRef = db.collection(COLLECTION_NAME).document(name)
                    try batch.setData(from: data, forDocument: cardRef)
                }
                batch.commit()
            } catch {
                print("Error: Cannot create firestore collection, \(error.localizedDescription)")
            }
            
        })
        
        
    }
    
}

