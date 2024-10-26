//
//  UpdatePasswordViewController.swift
//  GNUting
//
//  Created by 원동진 on 3/25/24.
//

// MARK: - 비밀번호 찾기 화면 ViewController

import UIKit

final class FindPasswordVC: BaseViewController {
    
    // MARK: - Properties
    
    private var timer = Timer()
    private var startTime: Date?
    private var emailSuccess = false
    private var samePasswordSuccess = false
    
    // MARK: - SubViews
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.isHidden = true
        
        return view
    }()
    
    private lazy var inputViewUpperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var emailInputView = EmailCheckTypeInputView()
    private lazy var certifiedInputView = AuthNumberInputView()
    private lazy var passWordInputView = makeCommonInputView(text: "비밀번호", placHolder: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자", textFieldType: .password)
    private lazy var passWordCheckInputView = makeCommonInputView(text: "비밀번호 확인", placHolder: "비밀번호와 동일하게 입력해주세요.", textFieldType: .passwordCheck)
    
    private lazy var passwordUpdateButton: PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("비밀번호 수정")
        button.isEnabled = false
        button.addAction(UIAction { _ in
            self.updatePasswordAPI()
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar(title: "비밀번호 찾기")
        setDelegateSubViews()
        setSecureTextEntry()
    }
}

extension FindPasswordVC {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        view.addSubViews([inputViewUpperStackView, passwordUpdateButton, activityIndicatorView])
        inputViewUpperStackView.addStackSubViews([emailInputView, certifiedInputView, passWordInputView, passWordCheckInputView])
        view.bringSubviewToFront(emailInputView)
    }
    
    private func setAutoLayout() {
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
    
    // MARK: - SetSubViews
    
    private func setDelegateSubViews() {
        emailInputView.emailCheckTypeInputViewDelegate = self
        certifiedInputView.authNumberInputViewDelegate = self
        passWordCheckInputView.passwordCheckDelegate = self
    }
    
    private func setSecureTextEntry() {
        passWordInputView.setSecureTextEntry()
        passWordCheckInputView.setSecureTextEntry()
    }
}

// MARK: - Private Method

extension FindPasswordVC {
    private func nextButtonEnable() {
        if emailSuccess && samePasswordSuccess {
            passwordUpdateButton.isEnabled = true
        } else {
            passwordUpdateButton.isEnabled = false
        }
    }
    
    private func setEmailCheckTime(limitSecond: Date) { // 시간 따로 변수 프로퍼티 만들어서 뺴기 struct 활용 ☑️
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

// MARK: - API

extension FindPasswordVC {
    private func updatePasswordAPI() {
        APIUpdateManager.shared.updatePassword(email: emailInputView.getTextFieldText(), password: passWordCheckInputView.getTextFieldText()) { response in
            if response.isSuccess {
                self.showAlertNavigationBack(message: "비밀번호가 수정되었습니다.",backType: .pop)
            } else {
                self.errorHandling(response: response)
            }
        }
    }
    
    private func postEmailCheckChangePasswordAPI(textFieldText: String) {
        APIPostManager.shared.postEmailCheckChangePassword(email: textFieldText + "@gnu.ac.kr") { response in
            self.showAlert(message: "인증번호가 전송되었습니다.")
            self.certifiedInputView.setFoucInputTextFiled()
            self.activityIndicatorView.stopAnimating()
            self.getSetTime()
        }
    }
    
    private func postAuthenticationCheckAPI(authNumber: String) {
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

// MARK: - Delegate

extension FindPasswordVC: EmailCheckTypeInputViewDelegate { // 이메일 인증
    func tapButtonAction(textFieldText: String) { // 이메일 인증 Button action
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        postEmailCheckChangePasswordAPI(textFieldText: textFieldText)
    }
    
    func didBeginTextfield() { // 이메일 입력 시작 action
        emailSuccess = false
        nextButtonEnable()
    }
}

extension FindPasswordVC: AuthNumberInputViewDelegate {
    func tapComfirmButtonAction(authNumber: String) { // 이메일 인증 번호 확인 버튼 action
        postAuthenticationCheckAPI(authNumber: authNumber)
    }
}

extension FindPasswordVC: PasswordCheckDelegate {
    func passwordCheckKeyboardReturn(text: String) { // 비밀번호 확인 입력 후 return or 확면 터치 Action
        let passwordTestFiledText = passWordInputView.getTextFieldText()
        let isPasswordMatch = passwordTestFiledText == text
        
        samePasswordSuccess = isPasswordMatch
        passWordCheckInputView.setInputCheckLabel(isHidden: false, text: isPasswordMatch ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.", success: isPasswordMatch)
        nextButtonEnable()
    }
}

// MARK: - Action

extension FindPasswordVC {
    @objc func getSetTime() {
        guard let startTime = startTime else {
            setEmailCheckTime(limitSecond: Date())
            return
        }
        setEmailCheckTime(limitSecond: startTime)
    }
}
