//
//  UserDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 4/9/24.
//

import UIKit

class UserDetailVC: UIViewController {
    var imaegURL : String?
    var userNickName: String?
    private lazy var userImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var reportButton : UIButton = {
       let button = UIButton()
        button.tintColor = UIColor(named: "IconColor")
        button.setImage(UIImage(named: "ReportImage"), for: .normal)
        button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        setUserImageView()
        setNavigationBar()
    }
}
extension UserDetailVC{
    private func setAddSubViews() {
        self.view.addSubview(userImageView)
    }
    private func setAutoLayout(){
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    private func setUserImageView() {
        setImageFromStringURL(stringURL: imaegURL) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
    }
    private func setNavigationBar() {
        setNavigationBarPresentType(title: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: reportButton)
    }
    @objc private func tapReportButton() {
        let vc = ReportVC()
        vc.userNickname = self.userNickName ?? "유저이름"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

