//
//  SignUpFirstProcess.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

// MARK: - 회원가입 1 단계 VC

import UIKit
import SnapKit

final class SignUpFirstProcessVC: BaseViewController {
    
    // MARK: - Properties
    
    var timer = Timer()
    var startTime: Date?
    var emailSuccess: Bool = false
    var samePasswordSuccess: Bool = false
    
    // MARK: - SubViews
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.isHidden = true
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let explainLabel: UILabel = {
        let label = UILabel()
        let text = "지누팅 서비스 이용을 위해서\n회원님의 정보가 필요해요:)"
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = Pretendard.bold(size: 22)
        let range = (text as NSString).range(of: "정보")
        let attribtuedString = NSMutableAttributedString(string: text)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryColor") ?? .red, range: range)
        label.attributedText = attribtuedString
        
        return label
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
    
    private lazy var nextButton: PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarSignUpProcess(imageName: "SignupImage1")
        addSubViews()
        setAutoLayout()
        setDelegateSubViews()
        setSecureTextEntry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - deinit
    
    deinit {
        timer.invalidate()
    }
}

// MARK: - Method

extension SignUpFirstProcessVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        view.addSubViews([scrollView, activityIndicatorView])
        scrollView.addSubViews([inputViewUpperStackView, nextButton])
        inputViewUpperStackView.addStackSubViews([explainLabel, emailInputView, certifiedInputView, passWordInputView, passWordCheckInputView])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
        
        inputViewUpperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.left.right.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        nextButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(inputViewUpperStackView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
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

extension SignUpFirstProcessVC {
    private func setEmailCheckTime(limitSecond : Date) {
        timer.invalidate()
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(limitSecond))
                let expireLimit = 180
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    self?.certifiedInputView.setCheckLabel(isHidden: false, text: "이메일 인증 시간 만료. 다시 시도해 주세요.",success: false)
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
    
    private func nextButtonEnable() {
        nextButton.isEnabled = emailSuccess == true && samePasswordSuccess
    }
}

// MARK: - API

extension SignUpFirstProcessVC {
    private func postAuthenticationCheckAPI(authNumber: String) { // 이메일 인증 번호 체크 API
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
    
    private func postEmailCheckAPI(textFieldText: String) {
        APIPostManager.shared.postEmailCheck(email: textFieldText + "@gnu.ac.kr") { response, failureResponse  in
            guard let success = response?.isSuccess else { return }
            
            if !(failureResponse?.isSuccess ?? true) {
                self.activityIndicatorView.stopAnimating()
                self.timer.invalidate()
                self.certifiedInputView.setRemainLabel(text: "")
                
                let USER4004CODE = failureResponse?.code == "USER4000-4"
                self.showMessage(message: USER4004CODE ? failureResponse?.message ?? "이미 존재하는 사용자입니다." : failureResponse?.message ?? "네트워크 에러 다시 시도하세요")
            }
            
            if success {
                self.showMessage(message: "인증번호가 전송되었습니다.")
                self.certifiedInputView.setFoucInputTextFiled()
                self.activityIndicatorView.stopAnimating()
                self.getSetTime()
            }
            
        }
    }
}

// MARK: - Delegate

extension SignUpFirstProcessVC: EmailCheckTypeInputViewDelegate {
    func tapButtonAction(textFieldText: String) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        postEmailCheckAPI(textFieldText: textFieldText)
    }
    
    func didBeginTextfield() {
        nextButton.isEnabled = false
    }
}
extension SignUpFirstProcessVC: AuthNumberInputViewDelegate {
    func tapComfirmButton(authNumber: String) {
        postAuthenticationCheckAPI(authNumber: authNumber)
    }
}
extension SignUpFirstProcessVC: PasswordCheckDelegate {
    func passwordCheckKeyboardReturn(text: String) {
        let passwordTestFiledText = passWordInputView.getTextFieldText()
        let isPasswordMatch = passwordTestFiledText == text
        
        samePasswordSuccess = isPasswordMatch
        passWordCheckInputView.setInputCheckLabel(isHidden: false, text: isPasswordMatch ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.", success: isPasswordMatch)
        nextButtonEnable()
    }
}

// MARK: - Action

extension SignUpFirstProcessVC {
    @objc private func tapNextButton() {
        SignUpModelManager.shared.setSignUpDictionary(setkey: "email", setData: emailInputView.getTextFieldText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "password", setData: passWordInputView.getTextFieldText())
        pushViewContoller(viewController: SignUPSecondProcessVC())
    }
    
    @objc func getSetTime() {
        guard let startTime = startTime else {
            setEmailCheckTime(limitSecond: Date())
            return
        }
        setEmailCheckTime(limitSecond: startTime)
    }
}
