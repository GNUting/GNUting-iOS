//
//  TabBarController.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit

class TabBarController: UITabBarController {
    var firstVC = UINavigationController.init(rootViewController: HomeVC())
    let secondVC = UINavigationController.init(rootViewController: RequestStatusVC())
    let thirdVC = UINavigationController.init(rootViewController: ChatVC())
    let forthVC = UINavigationController.init(rootViewController: MyPageVC())
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        print(email)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setTabBar(){
        self.viewControllers = [firstVC,secondVC,thirdVC,forthVC]
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home"), tag: 1)
        secondVC.tabBarItem = UITabBarItem(title: "신청현황", image: UIImage(named: "Request"), tag: 2)
        thirdVC.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "Chat"), tag: 3)
        forthVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "MyPage"), tag: 4)
        self.tabBar.tintColor = UIColor(named: "PrimaryColor")
    }

}

