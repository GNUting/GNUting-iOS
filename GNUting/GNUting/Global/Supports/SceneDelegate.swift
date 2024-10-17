//
//  SceneDelegate.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let loginState = UserDefaultsManager.shared.getLoginState() as? Bool
        
        let rootViewController: UIViewController = {
            if loginState ?? false {
                return TabBarController()
            } else {
                
                return UINavigationController.init(rootViewController: LoginVC())
            }
        }()
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        self.checkAndUpdateIfNeeded()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        let vc = GlobalUtil.currentTopViewController()
        
        if let chatRoomVC = vc as? ChatRoomVC {
            chatRoomVC.getAccessToken()
            chatRoomVC.initStomp()
        }
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        self.checkAndUpdateIfNeeded()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        let vc = GlobalUtil.currentTopViewController()
        
        if let chatRoomVC = vc as? ChatRoomVC {
            chatRoomVC.swiftStomp.disconnect()
        }
    }
    
    // 업데이트가 필요한지 확인 후 업데이트 알럿을 띄우는 메소드
    func checkAndUpdateIfNeeded() {
        _ = try? AppStoreVersionCheck.isUpdateAvailable(completion: { marketingVersion, error in
            DispatchQueue.main.async {
                guard let marketingVersion = marketingVersion else { // 앱스토어 버전
                    print("앱스토어 버전을 찾지 못했습니다.")
                    return
                }
                
                let currentProjectVersion = AppStoreVersionCheck.appVersion ?? "" // 현재 기기의 버전
                print("현재 기기버전 : \(currentProjectVersion), 앱스토어 버전 :\(marketingVersion)")
                
                let splitMarketingVersion = marketingVersion.split(separator: ".").map { $0 }
                let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map { $0 }
                if splitCurrentProjectVersion.count > 0 && splitMarketingVersion.count > 0 {
                    if splitCurrentProjectVersion[0] < splitMarketingVersion[0] {
                        self.showUpdateAlert(version: marketingVersion)
                    } else if splitCurrentProjectVersion[1] < splitMarketingVersion[1] {
                        self.showUpdateAlert(version: marketingVersion)
                    } else {
                        print("현재 최신 버전입니다.")
                    }
                }
            }
        })
    }
    
    // 알럿을 띄우는 메소드
    func showUpdateAlert(version: String) {
        let alert = UIAlertController(
            title: "업데이트 알림",
            message: "더 나은 서비스를 위해 옐로가 수정되었어요! 업데이트해주시겠어요?",
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            
            // 업데이트 버튼을 누르면 해당 앱스토어로 이동한다.
            AppStoreVersionCheck().openAppStore()
        }
        
        alert.addAction(updateAction)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

