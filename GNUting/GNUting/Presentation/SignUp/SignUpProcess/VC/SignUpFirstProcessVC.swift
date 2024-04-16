//
//  SignUpFirstProcess.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import UIKit
import SnapKit

class SignUpFirstProcessVC: UIViewController{
    var timer = Timer()
    var startTime : Date?
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
        signUPInpuView.setPlaceholder(placeholder: "인증번호를 입력해주세요.")
        signUPInpuView.confirmButtonDelegate = self
        signUPInpuView.setConfrimButton()
        signUPInpuView.setInputCheckLabel(textAlignment: .right)
        signUPInpuView.setKeyboardTypeNumberPad()
        return signUPInpuView
    }()
    private lazy var passWordInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "비밀번호")
        signUPInpuView.setPlaceholder(placeholder: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자")
        signUPInpuView.textFieldType = .password
        signUPInpuView.setSecureTextEntry()
        signUPInpuView.passwordInputDelegate = self
        return signUPInpuView
    }()
    private lazy var passWordCheckInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "비밀번호 확인")
        signUPInpuView.setPlaceholder(placeholder: "비밀번호와 동일하게 입력해주세요.")
        signUPInpuView.textFieldType = .passwordCheck
        signUPInpuView.passwordCheckDelegate = self
        signUPInpuView.setSecureTextEntry()
        
        return signUPInpuView
    }()
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    deinit {
        timer.invalidate()
    }
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
            make.top.greaterThanOrEqualTo(inputViewUpperStackView.snp.bottom).offset(20)
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
        guard let startTime = startTime else {
            setEmailCheckTime(limitSecond: Date())
            return
        }
        setEmailCheckTime(limitSecond: startTime)
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
                
                emailSuccess = true
                certifiedInputView.setCheckLabel(isHidden: false, text: "올바른 인증번호입니다.")
                timer.invalidate()
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
extension SignUpFirstProcessVC: PasswordInputDelegate {
    func passwordKeyboarReturn(text: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,15}"
        let checkPassword = text.range(of: regex,options: .regularExpression) != nil
        if !checkPassword {
            passWordInputView.setCheckLabel(isHidden: false, text: "특수문자, 영문자, 숫자 각 1개 이상 포함 8~15자에 해당 규칙을 준수해주세요.")
        }
    }
  
}

extension SignUpFirstProcessVC {
    private func setEmailCheckTime(limitSecond : Date) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(limitSecond))
                let expireLimit = 180
                
                guard elapsedTimeSeconds <= expireLimit else { // 시간 초과한 경우
                    timer.invalidate()
                    self?.certifiedInputView.setCheckLabel(isHidden: false, text: "이메일 인증 시간 만료. 다시 시도해 주세요.")
                    self?.emailInputView.setFoucInputTextFiled() // 이메일 다시하라고 포커스 주기
                    return
                }
                
                let remainSeconds = expireLimit - elapsedTimeSeconds
                let min = (remainSeconds % 3600) / 60
                let second = (remainSeconds % 3600) % 60
                
                if second < 10 {
                    self?.certifiedInputView.setCheckLabel(isHidden: false, text: String(min) + ":" + "0" + String(second))
                    
                } else {
                    self?.certifiedInputView.setCheckLabel(isHidden: false, text: String(min) + ":" + String(second))
                }
                
            }
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
