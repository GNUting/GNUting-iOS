//
//  FindPasswordVC.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import UIKit

class FindPasswordVC: UIViewController {
    private lazy var certifiedImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "CertifiedImg")
        return imgView
    }()
    private lazy var explainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        label.numberOfLines = 2
        label.textColor = .black
        label.setRangeTextFont(fullText: "가입시 등록한 학교 이메일로\n본인인증 후 Password를 찾을 수 있습니다.", range: "학교 이메일", uiFont: UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!)
        label.textAlignment = .center
        return label
    }()
    private lazy var emailCertifiedButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("메일 인증하기")
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        addSubViews()
        setAutoLayout()
        
    }
    
}
extension FindPasswordVC {
    private func addSubViews(){
        self.view.addSubViews([certifiedImageView,explainLabel,emailCertifiedButton])
    }
    private func setAutoLayout(){
        certifiedImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(200)
            make.centerX.equalToSuperview()
        }
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(certifiedImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        emailCertifiedButton.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(200)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
        }
    }
    private func setNavigationBar(){
        let popButton = UIBarButtonItem(image: UIImage(named: "PopImg"), style: .plain, target: self, action: #selector(popButtonTap))
        popButton.tintColor = UIColor(named: "Gray")
        self.navigationItem.leftBarButtonItem = popButton
        self.navigationItem.title = "비밀번호 찾기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
    }
}
