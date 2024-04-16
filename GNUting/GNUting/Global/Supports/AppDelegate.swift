//
//  AppDelegate.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/23.
//

import UIKit
import UserNotifications

import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        setupFCM(application)
        return true
    }
    private func setupFCM(_ application: UIApplication) {
           Messaging.messaging().delegate = self
           UNUserNotificationCenter.current().delegate = self
           UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { isAgree, error in
               if isAgree {
                   print("알림허용")
               }
           }
           application.registerForRemoteNotifications()
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


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    /// 푸시클릭시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("🟢", #function)
    }
    
    /// 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("🟢 userNotificationCenter", #function)
        
        return [.sound, .banner, .list,.badge]
    }
    
    /// FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        KeyChainManager.shared.create(key: "fcmToken", token: fcmToken)
        
        print("🟢", #function, "Token : \(fcmToken)")
    }
    

    /// error발생시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🟢", error)
    }
   

}

