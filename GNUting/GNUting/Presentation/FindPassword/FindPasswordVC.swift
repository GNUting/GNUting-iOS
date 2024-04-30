//
//  UpdatePasswordViewController.swift
//  GNUting
//
//  Created by 원동진 on 3/25/24.
//

import UIKit

class FindPasswordVC: UIViewController {
    var timer = Timer()
    var startTime : Date?
    var emailSuccess : Bool = false
    var samePasswordSuccess : Bool = false
  
    private lazy var inputViewUpperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var emailInputView : SignUpInputViewEmailCheckType = {
        let signUPInpuView = SignUpInputViewEmailCheckType()
        signUPInpuView.checkEmailButtonDelegate = self
        
        return signUPInpuView
    }()
    private lazy var certifiedInputView : SignUpInputViewAuthNumType = {
        let signUPInpuView = SignUpInputViewAuthNumType()
        signUPInpuView.confirmButtonDelegate = self
        return signUPInpuView
    }()
    private lazy var passWordInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "신규 비밀번호")
        
        signUPInpuView.setPlaceholder(placeholder: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자")
        signUPInpuView.textFieldType = .password
        signUPInpuView.passwordInputDelegate = self
        signUPInpuView.setSecureTextEntry()
        return signUPInpuView
    }()
    private lazy var passWordCheckInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "신규 비밀번호 확인")
        signUPInpuView.setPlaceholder(placeholder: "비밀번호 확인")
        signUPInpuView.textFieldType = .passwordCheck
        signUPInpuView.passwordCheckDelegate = self
        signUPInpuView.setSecureTextEntry()
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
extension FindPasswordVC {
    private func setAddView(){
        view.addSubViews([inputViewUpperStackView,passwordUpdateButton])
        inputViewUpperStackView.addStackSubViews([emailInputView,certifiedInputView,passWordInputView,passWordCheckInputView])
        
    }
    private func setAutoLayout(){
        inputViewUpperStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        passwordUpdateButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(inputViewUpperStackView.snp.bottom)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
    }
    private func setNavigationBar(){
        self.setNavigationBar(title: "비밀번호 찾기")
    }
    
}
extension FindPasswordVC {
    @objc func tapPasswordUpdateButton() {
      
        APIUpdateManager.shared.updatePassword(email: emailInputView.getTextFieldText(), password: passWordCheckInputView.getTextFieldText()) { response in
            if response.isSuccess {
                let alertController = UIAlertController(title: "비밀번호 업데이트", message: "수정된 비밀번호로 업데이트 되었습니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                    self.navigationController?.setViewControllers([LoginVC()], animated: true)
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
        
        guard let startTime = startTime else {
            setEmailCheckTime(limitSecond: Date())
            return
        }
        setEmailCheckTime(limitSecond: startTime)
    }
    private func nextButtonEnable() {
        if emailSuccess == true && samePasswordSuccess == true {
            passwordUpdateButton.isEnabled = true
        }else {
            passwordUpdateButton.isEnabled = false
        }
        
    }
    private func setEmailCheckTime(limitSecond : Date) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(limitSecond))
                let expireLimit = 180
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    self?.certifiedInputView.setCheckLabel(isHidden: false, text: "이메일 인증 시간 만료. 다시 시도해 주세요.", success: false)
                    self?.emailInputView.setFoucInputTextFiled() // 이메일 다시하라고 포커스 주기
                    return
                }
                
                let remainSeconds = expireLimit - elapsedTimeSeconds
                let min = (remainSeconds % 3600) / 60
                let second = (remainSeconds % 3600) % 60
                
                if second < 10 {
                    self?.certifiedInputView.setRemainLabel(text: String(min) + ":" + "0" + String(second))
                    
                } else {
                    self?.certifiedInputView.setRemainLabel(text: String(min) + ":" + String(second))
                }
                
            }
        }
    }
}
extension FindPasswordVC: CheckEmailButtonDelegate{
    func action(textFieldText: String) {
        APIPostManager.shared.postEmailCheckChangePassword(email: textFieldText + "@gnu.ac.kr") { response in
            print(response)
        }
        certifiedInputView.setFoucInputTextFiled()
        getSetTime()
    }
    
}
extension FindPasswordVC: ConfirmButtonDelegate{
    func action(sendTextFieldText: String) {
        
        APIPostManager.shared.postAuthenticationCheck(email: emailInputView.getTextFieldText() + "@gnu.ac.kr", number: sendTextFieldText) { [self] response  in
            if response.isSuccess {
                
                emailSuccess = true
                certifiedInputView.setCheckLabel(isHidden: false, text: "인증이 완료되었습니다.", success: true)
                nextButtonEnable()
            } else {
                certifiedInputView.setCheckLabel(isHidden: false, text: "인증번호가 일치하지 않습니다.", success: false)
            }
            
        }
    }
}
extension FindPasswordVC: PasswordCheckDelegate {
    func keyboarReturn(text: String) {
        let passwordTestFiledText = passWordInputView.getTextFieldText()
        
        if passwordTestFiledText == text {
            print("return")
            samePasswordSuccess = true
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: true, text: "비밀번호가 일치합니다.", success: true)
        }else {
            samePasswordSuccess = false
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: false, text: "비밀번호가 일치하지 않습니다.", success: false)
            
        }
    }
}
extension FindPasswordVC: PasswordInputDelegate {
    func passwordKeyboarReturn(text: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,15}"
        let checkPassword = text.range(of: regex,options: .regularExpression) != nil
        if !checkPassword {
            passWordInputView.setCheckLabel(isHidden: false, text: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자에 해당 규칙을 준수해주세요.", success: false)
        } else {
            passWordInputView.setCheckLabel(isHidden: true, text: "",success: true)
        }
    }
  
}
