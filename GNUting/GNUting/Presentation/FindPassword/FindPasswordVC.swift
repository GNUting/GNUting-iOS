//
//  UpdatePasswordViewController.swift
//  GNUting
//
//  Created by 원동진 on 3/25/24.
//

import UIKit

class FindPasswordVC: BaseViewController {
    var timer = Timer()
    var startTime : Date?
    var emailSuccess : Bool = false
    var samePasswordSuccess : Bool = false
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.isHidden = true
        return view
    }()
    private lazy var inputViewUpperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var emailInputView : EmailCheckTypeInputView = {
        let inputView = EmailCheckTypeInputView()
        inputView.emailCheckTypeInputViewDelegate = self
        
        return inputView
    }()
    
    private lazy var certifiedInputView : AuthNumberInputView = {
        let signUPInpuView = AuthNumberInputView()
        signUPInpuView.authNumberInputViewDelegate = self
        return signUPInpuView
    }()
    private lazy var passWordInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "신규 비밀번호")
        
        signUPInpuView.setPlaceholder(placeholder: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자")
        signUPInpuView.textFieldType = .password
        signUPInpuView.passwordDelegate = self
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
        
        setAddView()
        setAutoLayout()
        setNavigationBar()
    }
    
}
extension FindPasswordVC {
    private func setAddView(){
        view.addSubViews([inputViewUpperStackView,passwordUpdateButton,activityIndicatorView])
        inputViewUpperStackView.addStackSubViews([emailInputView,certifiedInputView,passWordInputView,passWordCheckInputView])
        view.bringSubviewToFront(emailInputView)
        
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
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
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
                self.showMessagePop(message: "비밀번호가 수정되었습니다.")
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
        timer.invalidate()
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
extension FindPasswordVC: EmailCheckTypeInputViewDelegate{
    func tapButtonAction(textFieldText: String) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()

        APIPostManager.shared.postEmailCheckChangePassword(email: textFieldText + "@gnu.ac.kr") { response in
            self.showMessage(message: "인증번호가 전송되었습니다.")
            self.certifiedInputView.setFoucInputTextFiled()
            self.activityIndicatorView.stopAnimating()
            self.getSetTime()
        }
    }
    
    func didBeginTextfield() {
        emailSuccess = false
        nextButtonEnable()
    }
    
}
extension FindPasswordVC: AuthNumberInputViewDelegate{
    func tapComfirmButton(authNumber: String) {
        APIPostManager.shared.postAuthenticationCheck(email: emailInputView.getTextFieldText() + "@gnu.ac.kr", number: authNumber) { [self] response  in
            if response.isSuccess {
                
                emailSuccess = true
                certifiedInputView.setCheckLabel(isHidden: false, text: "인증이 완료되었습니다.", success: true)
                timer.invalidate()
                nextButtonEnable()
                
            } else {
                certifiedInputView.setCheckLabel(isHidden: false, text: "인증번호가 일치하지 않습니다.", success: false)
            }
            
        }
    }
}
extension FindPasswordVC: PasswordCheckDelegate {
    func passwordCheckKeyboardReturn(text: String) {
        let passwordTestFiledText = passWordInputView.getTextFieldText()
        
        if passwordTestFiledText == text {
            samePasswordSuccess = true
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: false, text: "비밀번호가 일치합니다.", success: true)
        }else {
            samePasswordSuccess = false
            nextButtonEnable()
            passWordCheckInputView.setCheckLabel(isHidden: false, text: "비밀번호가 일치하지 않습니다.", success: false)
            
        }
    }
}
extension FindPasswordVC: PasswordDelegate {
    func passwordkeyBoardReturn(text: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,15}"
        let checkPassword = text.range(of: regex,options: .regularExpression) != nil
        if !checkPassword {
            passWordInputView.setCheckLabel(isHidden: false, text: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자에 해당 규칙을 준수해주세요.", success: false)
        } else {
            passWordInputView.setCheckLabel(isHidden: false, text: "올바른 규칙의 비밀번호입니다.", success: true)
        }
    }
}
