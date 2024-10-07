//
//  SignUPSecondProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

// MARK: - 회원가입 2 단계 VC

import UIKit

final class SignUPSecondProcessVC: BaseViewController {
    
    // MARK: - Properties
    
    private var selectedDate : String = ""
    private var nickNameCheck: Bool = false
    private var phoneNumberCheck: Bool = false
    
    // MARK: - SubViews
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var inputViewUpperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var nameInputView = makeCommonInputView(text: "이름", placHolder: "이름을 입력해주세요.", textFieldType: .name)
    private lazy var phoneNumberInputView = makeCommonInputView(text: "전화번호", placHolder: "전화번호를 입력해주세요.", textFieldType: .phoneNumber)
    private lazy var studentIDInputView = makeCommonInputView(text: "학번", placHolder: "입학년도만 입력해주세요 EX 24 ", textFieldType: .studentID)
    private lazy var introduceOneLine = makeCommonInputView(text: "한줄소개", placHolder: "자신을 한줄로 표현해주세요.(30자 제한)", textFieldType: .introduce)
    private lazy var genderView = SelectGenderView()
    private lazy var nickNameInputView = NicknameTypeInputView()
    private lazy var majorInputView = MajorInputView()
    
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Date 선택 관련 View
    
    private lazy var blurEffect = UIBlurEffect(style: .regular)
    
    private lazy var bluerEffectView : UIVisualEffectView = {
        let bluerEffectView = UIVisualEffectView(effect: blurEffect)
        bluerEffectView.alpha = 0
        bluerEffectView.frame = self.view.bounds
        
        return bluerEffectView
    }()
    
    private lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.date = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(changeDate(_ :)), for: .valueChanged)
        
        return datePicker
        
    }()
    
    private lazy var selectDateView : SelectDateView = {
        let selectDateView = SelectDateView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectDateView))
        selectDateView.addGestureRecognizer(tapGesture)
        
        return selectDateView
    }()
    
    private lazy var buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var dateViewCacnelButton = makeDateViewButton(title: "취소", titleColor: .red, action: #selector(tapCanelButton))
    private lazy var dateViewSelectButton = makeDateViewButton(title: "선택", titleColor: .black, action: #selector(tapSelectButton))
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarSignUpProcess(imageName: "SignupImage2")
        addSubViews()
        setAutoLayout()
        setDelegateSubViews()
        setPhoneNumberInputView()
    }
    
}

// MARK: - Method

extension SignUPSecondProcessVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        self.view.addSubViews([scrollView, datePicker, bluerEffectView, buttonStackView])
        scrollView.addSubViews([inputViewUpperStackView, nextButton])
        inputViewUpperStackView.addStackSubViews([nameInputView, phoneNumberInputView, genderView, selectDateView, nickNameInputView, majorInputView, studentIDInputView, introduceOneLine])
        buttonStackView.addStackSubViews([dateViewCacnelButton, dateViewSelectButton])
    }
    
    private func setAutoLayout(){
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
        
        inputViewUpperStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(inputViewUpperStackView.snp.bottom).offset(Spacing.top)
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalToSuperview()
        }
        
        // MARK: - DateFicker 선택시 출력 되는 화면에 대한 Auto Layout
        
        datePicker.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom)
            make.centerX.equalToSuperview()
            
        }
    }
    
    // MARK: - SetSubView
    
    private func setDelegateSubViews() {
        nameInputView.inputViewTextFiledDelegate = self
        phoneNumberInputView.inputViewTextFiledDelegate = self
        phoneNumberInputView.phoneNumberDelegate = self
        nickNameInputView.nicknameCheckButtonDelegate = self
        nickNameInputView.nicknameTextfiledDelegate = self
        majorInputView.majorInputViewDelegate = self
        studentIDInputView.inputViewTextFiledDelegate = self
        introduceOneLine.inputViewTextFiledDelegate = self
    }
    
    private func setPhoneNumberInputView() {
        phoneNumberInputView.setKeyboardTypeNumberPad()
    }
    
    // MARK: - Privatge
    
    private func checkEnableNextButton() { // 다음 버튼 활성화 Check
        if nickNameCheck && phoneNumberCheck && !nameInputView.isEmpty() && !phoneNumberInputView.isEmpty() && !majorInputView.isEmpty() && !studentIDInputView.isEmpty() && !selectedDate.isEmpty {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    private func makeDateViewButton(title: String, titleColor: UIColor,action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for:.normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
}

// MARK: - API

extension SignUPSecondProcessVC {
    private func checkNicknameAPI(nickname: String) {
        APIGetManager.shared.checkNickname(nickname: nickname) { response  in
            guard let success = response?.isSuccess else { return }
            if success {
                self.nickNameCheck = true
                self.nickNameInputView.setCheckLabel(isHidden: false, text: "사용할 수 있는 닉네임 입니다.", success: true)
                self.checkEnableNextButton()
            } else {
                self.nickNameCheck = false
                self.nickNameInputView.setCheckLabel(isHidden: false, text: response?.message, success: false)
            }
        }
    }
}

// MARK: - delegate

extension SignUPSecondProcessVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // 수평 스크롤 제한
        if scrollView.contentOffset.x > 0{
            scrollView.contentOffset.x = 0
        }
    }
}

extension SignUPSecondProcessVC: NicknameTextfiledDelegate { // 닉네임 입력
    func endEdit() {
        checkEnableNextButton()
    }
    
    func didBegin() {
        nickNameCheck = false
    }
}

extension SignUPSecondProcessVC :NicknameCheckButtonDelegate { // 닉네임 인증 버튼 클릭 aciton
    func action(textFieldText: String) {
        checkNicknameAPI(nickname: textFieldText)
    }
}

extension SignUPSecondProcessVC: MajorInputViewDelegate { // 학과 입력 View 클릭 action
    func tapMajorInputView() {
        let vc = SearchMajorVC()
        let navigationVC = UINavigationController(rootViewController: vc)
        
        vc.searchMajorSelectCellDelegate = self
        present(navigationVC, animated: true)
        checkEnableNextButton()
    }
}

extension SignUPSecondProcessVC: SearchMajorSelectCellDelegate { // 선택한 학과 send
    func sendSeleceted(major: String) {
        majorInputView.setContentLabelText(text: major)
        checkEnableNextButton()
    }
}

extension SignUPSecondProcessVC: InputViewTextFiledDelegate { // 입력 여부 확인
    func shouldEndEdting() {
        checkEnableNextButton()
    }
}
extension SignUPSecondProcessVC: PhoneNumberDelegate { // 전화번호 입력 체크
    func phoneNumberKeyBoardReturn(textFieldCount: Int) {
        if textFieldCount == 13 {
            phoneNumberCheck = true
            phoneNumberInputView.setInputCheckLabel(isHidden: false, text: "올바른 전화번호입니다.", success: true)
        } else {
            phoneNumberCheck = false
            phoneNumberInputView.setInputCheckLabel(isHidden: false, text: "전화번호 입력이 올바르지 않습니다.", success: false)
        }
    }
}

// MARK: - Button Action

extension SignUPSecondProcessVC {
    @objc private func tapSelectDateView(){
        view.endEditing(true)
        datePicker.isHidden = false
        buttonStackView.isHidden = false
        view.bringSubviewToFront(datePicker)
        view.bringSubviewToFront(buttonStackView)
        bluerEffectView.alpha = 1
    }
    
    @objc private func changeDate(_ sender : UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        selectedDate = formatter.string(from: sender.date)
        checkEnableNextButton()
    }
    
    @objc private func tapSelectButton(){
        datePicker.isHidden = true
        buttonStackView.isHidden = true
        bluerEffectView.alpha = 0
        let dateArr = selectedDate.split(separator: "-").map{String($0)}
        
        if dateArr.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let today = formatter.string(from: Date()).split(separator: "-").map{String($0)}
            
            selectDateView.setDateLabel(date: DateModel(year: today[0], momth: today[1], day: today[2]))
        } else {
            selectDateView.setDateLabel(date: DateModel(year: dateArr[0], momth: dateArr[1], day: dateArr[2]))
        }
        
        if selectedDate.isEmpty {
            showMessage(message: "생년월일을 올바르게 입력하세요.")
        }
    }
    @objc private func tapCanelButton(){
        datePicker.isHidden = true
        buttonStackView.isHidden = true
        bluerEffectView.alpha = 0
        
    }
    
    @objc private func tapNextButton(){
        SignUpModelManager.shared.setSignUpDictionary(setkey: "name", setData: nameInputView.getTextFieldText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "phoneNumber", setData: phoneNumberInputView.getTextFieldText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "gender", setData: genderView.getSelectedGender())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "birthDate", setData: selectedDate)
        SignUpModelManager.shared.setSignUpDictionary(setkey: "nickname", setData: nickNameInputView.getTextFieldText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "department", setData: majorInputView.getContentLabelText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "studentId", setData: studentIDInputView.getTextFieldText())
        SignUpModelManager.shared.setSignUpDictionary(setkey: "userSelfIntroduction", setData: introduceOneLine.getTextFieldText())
        
        pushViewContoller(viewController: SignUpThirdProcessVC())
    }
}
