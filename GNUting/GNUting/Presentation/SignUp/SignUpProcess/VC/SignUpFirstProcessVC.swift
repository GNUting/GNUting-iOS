//
//  SignUpFirstProcess.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import UIKit
import SnapKit

class SignUpFirstProcessVC: UIViewController{
    
    var limitTime : Int = 60 // 180 바꿔야함
    var emailSuccess : Bool = false
    var samePasswordSuccess : Bool = false
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
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
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var emailInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "이메일")
        signUPInpuView.setConfirmButton(text: "인증받기")
        signUPInpuView.setPlaceholder(placeholder: "이메일을 입력해주세요.")
        signUPInpuView.isEmailTextField(emailField: true)
        signUPInpuView.checkEmailButtonDelegate = self
        signUPInpuView.setCheckEmailAction()
        
        return signUPInpuView
    }()
    private lazy var certifiedInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "인증번호")
        signUPInpuView.setConfirmButton(text: "확인")
        signUPInpuView.setPlaceholder(placeholder: "인증 번호를 입력해주세요.")
        signUPInpuView.confirmButtonDelegate = self
        signUPInpuView.setConfrimButton()
        signUPInpuView.setInputCheckLabel(textAlignment: .right)
        return signUPInpuView
    }()
    private lazy var passWordInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "비밀번호")
        signUPInpuView.setPlaceholder(placeholder: "비밀 번호를 입력해주세요.")
        signUPInpuView.textFieldType = .password
        
        return signUPInpuView
    }()
    private lazy var passWordCheckInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "비밀번호 확인")
        signUPInpuView.setPlaceholder(placeholder: "비밀번호와 동일하게 입력해주세요.")
        signUPInpuView.textFieldType = .passwordCheck
        signUPInpuView.passwordCheckDelegate = self
        
        return signUPInpuView
    }()
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        button.isEnabled = true
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar(title: "1/3")
        addSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

// MARK: - Set View/UI

extension SignUpFirstProcessVC{
    private func addSubViews(){
        view.addSubview(scrollView)
        scrollView.addSubViews([inputViewUpperStackView,nextButton])
        inputViewUpperStackView.addStackSubViews([explainLabel,emailInputView,certifiedInputView,passWordInputView,passWordCheckInputView])
    }
    
    private func setAutoLayout(){
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
        
        inputViewUpperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.right.equalToSuperview()
            
            make.width.equalTo(scrollView.snp.width)
            
        }
        nextButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(inputViewUpperStackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: - Action
extension SignUpFirstProcessVC{
    @objc private func tapNextButton(){
        let vc = SignUPSecondProcessVC()
        SignUpModelManager.shared.setSignUpDictionary(setkey: "email", setData: emailInputView.getTextFieldText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "password", setData: passWordInputView.getTextFieldText())
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func getSetTime() {
        
        if limitTime > 0 {
            setEmailCheckTime(limitSecond: limitTime)
            limitTime -= 1
        } else if limitTime == 0 {
            certifiedInputView.setCheckLabel(isHidden: true, text: nil)
            emailInputView.setFoucInputTextFiled() // 이메일 다시하라고 포커스 주기
            let alert = UIAlertController(title: "이메일 인증시간 만료", message: "이메일 인증을 다시 시도해주세요.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            
            limitTime = 60 // 180 바꿔야함
            
        }
    }
}
extension SignUpFirstProcessVC: CheckEmailButtonDelegate{
    func action(textFieldText: String) {
        APIPostManager.shared.postEmailCheck(email: textFieldText + "@gnu.ac.kr")
        certifiedInputView.setFoucInputTextFiled()
        getSetTime()
    }
    
}
extension SignUpFirstProcessVC: ConfirmButtonDelegate{
    func action(sendTextFieldText: String) {
    
        APIPostManager.shared.postAuthenticationCheck(email: emailInputView.getTextFieldText() + "@gnu.ac.kr", number: sendTextFieldText) { [self] response  in
            
            
            if response.isSuccess {
                limitTime = -1
                emailSuccess = true
                certifiedInputView.setCheckLabel(isHidden: false, text: "올바른 인증번호입니다.")
                nextButtonEnable()
            } else {
                let alert = UIAlertController(title: "인증번호가 올바르지 않습니다.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                certifiedInputView.setCheckLabel(isHidden: false, text: "인증 번호가 올바르지 않습니다.")
                present(alert, animated: true)
            }
            
        }
//        if checkNumber == sendTextFieldText {
//            limitTime = -1
//            emailSuccess = true
//            certifiedInputView.setCheckLabel(isHidden: false, text: "올바른 인증번호입니다.")
//            nextButtonEnable()
//        } else {
//            emailSuccess = false
//            nextButtonEnable()
//            certifiedInputView.setCheckLabel(isHidden: false, text: "인증번호가 올바르지 않습니다.")
//            let alert = UIAlertController(title: "인증번호가 올바르지 않습니다.", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
//            present(alert, animated: true)
//            
//        }
    }
    
}
extension SignUpFirstProcessVC: PasswordCheckDelegate {
    func keyboarReturn(text: String) {
        let passwordTestFiledText = passWordInputView.getTextFieldText()
        if passwordTestFiledText == text {
            samePasswordSuccess = true
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: true, text: nil)
        }else {
            samePasswordSuccess = false
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: false, text: "비밀번호가 일치하지 않습니다.")
            
        }
    }
}


extension SignUpFirstProcessVC {
    private func setEmailCheckTime(limitSecond : Int) {
        let min = (limitSecond % 3600) / 60
        let second = (limitSecond % 3600) % 60
        
        if second < 10 {
            certifiedInputView.setCheckLabel(isHidden: false, text: String(min) + ":" + "0" + String(second))
            
        } else {
            certifiedInputView.setCheckLabel(isHidden: false, text: String(min) + ":" + String(second))
        }
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        }
    }
    private func nextButtonEnable() {
        if emailSuccess == true && samePasswordSuccess == true {
            nextButton.isEnabled = true
        }else {
            nextButton.isEnabled = false
        }
        
    }
}
