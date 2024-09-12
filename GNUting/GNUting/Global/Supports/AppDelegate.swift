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
        UITabBar.appearance().backgroundColor = .white
        FirebaseApp.configure()
        setupFCM(application)
        sleep(UInt32(2))
        NetworkMonitor.shared.startMonitoring()
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
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    /// 푸시클릭시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let location = userInfo[AnyHashable("location")] as? String
        guard let locationID = userInfo[AnyHashable("locationId")] as? String else { return }
        
        let rootVC = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController as? UITabBarController
        switch location {
        case "apply":
            rootVC?.selectedIndex = 1
            let vc = currentTopViewController() as? RequestStateVC
            vc?.selectedSegmentIndex = 1
            vc?.getApplicationReceivedData(ApplicatoinID: locationID, requestStatus: false)
            
        case "cancel":
            rootVC?.selectedIndex = 1
            let vc = currentTopViewController() as? RequestStateVC
            vc?.selectedSegmentIndex = 1
        case "refuse":
            
            rootVC?.selectedIndex = 1
            let vc = currentTopViewController() as? RequestStateVC
            vc?.selectedSegmentIndex = 0
            vc?.getApplicationReceivedData(ApplicatoinID: locationID, requestStatus: true)
        case "chat":
            rootVC?.selectedIndex = 2
            let chatRoomVC = ChatRoomVC()
            
            chatRoomVC.isPushNotification = true
            chatRoomVC.chatRoomID = Int(locationID) ?? 0
            rootVC?.pushViewContoller(viewController: chatRoomVC)
        case .none:
            break
        case .some(_):
            break
        }
      
    }
    
    /// 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        let location = userInfo[AnyHashable("location")] as? String
        let locationID = userInfo[AnyHashable("locationId")] as? String ?? "0"
        let chatRoomID = ChatVisibleManager.shared.chatRoomID
        let chatRoomVisible = ChatVisibleManager.shared.isChatRoom
        
        if location == "chat" && chatRoomVisible == true && chatRoomID == Int(locationID) ?? 0{
            
        } else {
            return [.sound, .banner, .list,.badge]
        }
        return []
    }
    
    /// FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        KeyChainManager.shared.create(key: "fcmToken", token: fcmToken)
        
        print("🟢", #function)
    }
    
    
    // error발생시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🔴", error)
    }
    func currentTopViewController(controller: UIViewController? = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return currentTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabbarController = controller as? UITabBarController {
            if let selected = tabbarController.selectedViewController {
                return currentTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return currentTopViewController(controller: presented)
        }
        return controller
        
    }
}
