//
//  SignUpFirstProcess.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import UIKit

class SignUpFirstProcessVC: UIViewController {
    private let explainLabel : UILabel = {
        let label = UILabel()
        label.text = "지누팅 서비스 이용을 위해서\n회원님의 정보가 필요해요."
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 22)
        return label
    }()
    private lazy var inputViewUpperStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var emailInputView : SignUPInpuView = {
       let signUPInpuView = SignUPInpuView()
        signUPInpuView.setInputTextTypeLabel(text: "이메일")
        signUPInpuView.setConfirmButton(text: "인증받기")
        signUPInpuView.setPlaceholder(placeholder: "이메일을 입력해주세요.")
        signUPInpuView.isEmailTextField(eamilField: true)
        signUPInpuView.setAddButton(AddButton: true)
        return signUPInpuView
    }()
    private lazy var certifiedInputView : SignUPInpuView = {
       let signUPInpuView = SignUPInpuView()
        signUPInpuView.setInputTextTypeLabel(text: "인증번호")
        signUPInpuView.setConfirmButton(text: "확인")
        signUPInpuView.setPlaceholder(placeholder: "인증 번호를 입력해주세요.")
        signUPInpuView.setAddButton(AddButton: true)
        return signUPInpuView
    }()
    private lazy var passWordInputView : SignUPInpuView = {
       let signUPInpuView = SignUPInpuView()
        signUPInpuView.setInputTextTypeLabel(text: "비밀번호")
        signUPInpuView.setPlaceholder(placeholder: "비밀 번호를 입력해주세요.")
        return signUPInpuView
    }()
    private lazy var passWordCheckInputView : SignUPInpuView = {
       let signUPInpuView = SignUPInpuView()
        signUPInpuView.setInputTextTypeLabel(text: "비밀번호 확인")
        signUPInpuView.setPlaceholder(placeholder: "비밀번호와 동일하게 입력해주세요.")
        return signUPInpuView
    }()
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        addSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
extension SignUpFirstProcessVC{
    private func addSubViews(){
        self.view.addSubViews([explainLabel,inputViewUpperStackView,nextButton])
        inputViewUpperStackView.addStackSubViews([emailInputView,certifiedInputView,passWordInputView,passWordCheckInputView])
    }
    private func setAutoLayout(){
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        inputViewUpperStackView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
        }
    }
    private func setNavigationBar(){
        let popButton = UIBarButtonItem(image: UIImage(named: "PopImg"), style: .plain, target: self, action: #selector(popButtonTap))
        popButton.tintColor = UIColor(named: "Gray")
        self.navigationItem.leftBarButtonItem = popButton
        self.navigationItem.title = "1/3"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
    }
}
//MARK: - Action
extension SignUpFirstProcessVC{
    @objc private func tapNextButton(){
        let vc = SignUPSecondProcessVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
