//
//  UpdatePasswordViewController.swift
//  GNUting
//
//  Created by 원동진 on 3/25/24.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    var limitTime : Int = 180 // 180 바꿔야함
    var emailSuccess : Bool = false
    var samePasswordSuccess : Bool = false
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
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
        signUPInpuView.setInputTextTypeLabel(text: "수정 비밀번호")
        signUPInpuView.setPlaceholder(placeholder: "수정할 비밀 번호를 입력해주세요.")
        signUPInpuView.textFieldType = .password
        
        return signUPInpuView
    }()
    private lazy var passWordCheckInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "수정 비밀번호 확인")
        signUPInpuView.setPlaceholder(placeholder: "수정 비밀번호와 동일하게 입력해주세요.")
        signUPInpuView.textFieldType = .passwordCheck
        signUPInpuView.passwordCheckDelegate = self
        
        return signUPInpuView
    }()
    private lazy var passwordUpdateButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("비밀번호 수정")
        button.addTarget(self, action: #selector(tapPasswordUpdateButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setAddView()
        setAutoLayout()
        setNavigationBar()
    }
    
}
extension UpdatePasswordViewController {
    private func setAddView(){
        view.addSubview(scrollView)
        inputViewUpperStackView.addStackSubViews([emailInputView,certifiedInputView,passWordInputView,passWordCheckInputView])
        scrollView.addSubViews([inputViewUpperStackView,passwordUpdateButton])
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
        passwordUpdateButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(inputViewUpperStackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    private func setNavigationBar(){
        self.setNavigationBar(title: "비밀번호 찾기")
    }
    
}
extension UpdatePasswordViewController {
    @objc func tapPasswordUpdateButton() {
      
        APIUpdateManager.shared.updatePassword(email: emailInputView.getTextFieldText(), password: passWordCheckInputView.getTextFieldText()) { response in
            if response.isSuccess {
                let alertController = UIAlertController(title: "비밀번호 업데이트", message: "수정된 비밀번호로 업데이트 되었습니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                    self.navigationController?.setViewControllers([AppStartVC(),LoginVC()], animated: true)
                }))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            }else {
                self.errorHandling(response: response)
            }
        }
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
            
            limitTime = 180 // 180 바꿔야함
            
        }
    }
    private func nextButtonEnable() {
        if emailSuccess == true && samePasswordSuccess == true {
            passwordUpdateButton.isEnabled = true
        }else {
            passwordUpdateButton.isEnabled = false
        }
        
    }
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
}
extension UpdatePasswordViewController: CheckEmailButtonDelegate{
    func action(textFieldText: String) {
        APIPostManager.shared.postEmailCheck(email: textFieldText + "@gnu.ac.kr")
        certifiedInputView.setFoucInputTextFiled()
        getSetTime()
    }
    
}
extension UpdatePasswordViewController: ConfirmButtonDelegate{
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
    }
}
extension UpdatePasswordViewController: PasswordCheckDelegate {
    func keyboarReturn(text: String) {
        let passwordTestFiledText = passWordInputView.getTextFieldText()
        
        if passwordTestFiledText == text {
            print("return")
            samePasswordSuccess = true
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: true, text: "비밀번호가 일치합니다.")
        }else {
            samePasswordSuccess = false
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: false, text: "비밀번호가 일치하지 않습니다.")
            
        }
    }
}
