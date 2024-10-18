//
//  GlobalUtil.swift
//  GNUting
//
//  Created by 원동진 on 10/17/24.
//

import UIKit

final class GlobalUtil {
    static func currentTopViewController(controller: UIViewController? = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        
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
