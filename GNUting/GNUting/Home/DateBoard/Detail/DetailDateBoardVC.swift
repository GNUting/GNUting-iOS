//
//  DetailDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/20/24.
//

import UIKit

class DetailDateBoardVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        setNavigationBar()
    }
}
extension DetailDateBoardVC{
    private func addSubViews() {
        
    }
    private func setAutoLayout(){
        
    }
    private func setNavigationBar(){
        let backButton = BackButton()
        backButton.setConfigure(text: "")
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.title = "과팅 게시판"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
        let settingButton = UIBarButtonItem(image: UIImage(named: "SettingButton"), style: .plain, target: self, action: #selector(tapSettingButton))
        settingButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = settingButton
    }
}
extension DetailDateBoardVC{
    @objc private func tapSettingButton(){
        
    }
}
