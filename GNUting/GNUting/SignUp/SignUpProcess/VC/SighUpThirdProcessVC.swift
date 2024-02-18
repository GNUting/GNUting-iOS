//
//  SighUpThirdProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/11/24.
//

import UIKit
import SnapKit
class SighUpThirdProcessVC: UIViewController {
    private lazy var phothImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photoImg")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhothImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    private let explainLabel : UILabel = {
        let uiLabel = UILabel()
        let fullText = "아이콘을 눌러\n회원님의 프로필 사진을 등록해주세요."
        uiLabel.numberOfLines = 2
        uiLabel.textAlignment = .center
        uiLabel.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        uiLabel.text = fullText
        uiLabel.setRangeTextFont(fullText: fullText, range: "프로필 사진", uiFont: UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!)
        return uiLabel
    }()
    private lazy var signUpCompltedButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("가입 완료")
        button.addTarget(self, action: #selector(tapSignUpCompltedButton), for: .touchUpInside)
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
extension SighUpThirdProcessVC{
    private func addSubViews(){
        self.view.addSubViews([phothImageView,explainLabel,signUpCompltedButton])
    }
    private func setAutoLayout(){
        phothImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(2.0/3.0)
        }
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(phothImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        signUpCompltedButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
    private func setNavigationBar(){
        let backButton = BackButton()
        backButton.setConfigure(text: "")
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        let popButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = popButton
        self.navigationItem.title = "3/3"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
    }
    
}
extension SighUpThirdProcessVC {
    @objc private func tapPhothImageView(){
        let alert = UIAlertController(title: "프로필 사진을 등록해주세요.", message: "다른 회원들에게 보여지는 회원님만의 프로필 사진을 등록해주세요.\n앱을 사용하는 동안 지누팅 사용자 간의 원활한 대화가 이루어집니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "등록하기", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    @objc private func tapSignUpCompltedButton(){
        let alert = UIAlertController(title: "가입 완료", message: "가입이 완료 되었습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "등록하기", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
