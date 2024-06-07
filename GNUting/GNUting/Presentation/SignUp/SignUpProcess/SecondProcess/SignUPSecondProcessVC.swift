//
//  SignUPSecondProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import UIKit

class SignUPSecondProcessVC: BaseViewController{
    
    var selectedDate : String = ""
    var nickNameCheck: Bool = false
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
    private lazy var nameInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "이름")
        signUPInpuView.setPlaceholder(placeholder: "이름을 입력해주세요.")
        signUPInpuView.textFieldType = .name
        signUPInpuView.inputViewTextFiledDelegate = self
        return signUPInpuView
    }()
    private lazy var phoneNumberInputView : SignUPInputView = {
        let signUPInpuView = SignUPInputView()
        signUPInpuView.setInputTextTypeLabel(text: "전화번호")
        signUPInpuView.setPlaceholder(placeholder: "전화번호를 입력해주세요.")
        signUPInpuView.textFieldType = .phoneNumber
        signUPInpuView.setKeyboardTypeNumberPad()
        signUPInpuView.inputViewTextFiledDelegate = self
        return signUPInpuView
    }()
    private lazy var genderView : SelectGenderView = {
        let genderView = SelectGenderView()
        
        return genderView
    }()
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
    private lazy var dateViewCacnelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.red, for:.normal)
        button.addTarget(self, action: #selector(tapCanelButton), for: .touchUpInside)
        return button
    }()
    private lazy var dateViewSelectButton : UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.black, for:.normal)
        button.addTarget(self, action: #selector(tapSelectButton), for: .touchUpInside)
        return button
    }()
    private lazy var nickNameInputView : SignUpInputViewNicknameType = {
        let nickNameInputView = SignUpInputViewNicknameType()
        nickNameInputView.nicknameCheckButtonDelegate = self
        nickNameInputView.nicknameTextfiledDelegate = self
        return nickNameInputView
    }()
    private lazy var majorInputView : MajorInputView = {
        let majorInputView = MajorInputView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMajorInputView))
        majorInputView.isUserInteractionEnabled = true
        majorInputView.addGestureRecognizer(tapGesture)
        
        return majorInputView
    }()
    private lazy var studentIDInputView : SignUPInputView = {
        let studentIDInputView = SignUPInputView()
        studentIDInputView.setInputTextTypeLabel(text: "학번")
        studentIDInputView.setPlaceholder(placeholder: "입학년도만 입력해주세요 EX 24 ")
        studentIDInputView.setKeyboardTypeNumberPad()
        studentIDInputView.textFieldType = .studentID
        studentIDInputView.inputViewTextFiledDelegate = self
        return studentIDInputView
    }()
    
    private lazy var introduceOneLine : SignUPInputView = {
        let studentIDInputView = SignUPInputView()
        studentIDInputView.setInputTextTypeLabel(text: "한줄소개")
        studentIDInputView.setPlaceholder(placeholder: "자신을 한줄로 표현해주세요.(30자 제한)")
        studentIDInputView.textFieldType = .introduce
        return studentIDInputView
    }()
    
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarSignUpProcess(imageName: "SignupImage2")
        addSubViews()
        setAutoLayout()
    }
    
}

// MARK: - Set View/UI

extension SignUPSecondProcessVC{
    private func addSubViews(){
        self.view.addSubViews([scrollView,datePicker,bluerEffectView,buttonStackView])
        scrollView.addSubViews([inputViewUpperStackView,nextButton])
        inputViewUpperStackView.addStackSubViews([nameInputView,phoneNumberInputView,genderView,selectDateView,nickNameInputView,majorInputView,studentIDInputView,introduceOneLine])
        buttonStackView.addStackSubViews([dateViewCacnelButton,dateViewSelectButton])
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
        // MARK: - DateFicker 선택
        datePicker.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom)
            make.centerX.equalToSuperview()
            
        }
        
    }
    private func checkEnableNextButton(){
        if nickNameCheck == true && !nameInputView.isEmpty() && !phoneNumberInputView.isEmpty() && !majorInputView.isEmpty() && !studentIDInputView.isEmpty() && phoneNumberInputView.getTextFieldText().count == 13{
            nextButton.isEnabled = true
        } 
        else {
            nextButton.isEnabled = false
        }
    }
}

// MARK: - ScrollView delegate

extension SignUPSecondProcessVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0{
            scrollView.contentOffset.x = 0
        }
    }
}


//MARK: - Button Action

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
    @objc private func tapMajorInputView() {
        
        let vc = SearchMajorVC()
        vc.searchMajorSelectCellDelegate = self
        
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true)
        checkEnableNextButton()
    }
}
extension SignUPSecondProcessVC :NicknameCheckButtonDelegate {
    func action(textFieldText: String) {
        if textFieldText.isEmpty {
            nickNameInputView.setCheckLabel(isHidden: false, text: "닉네임을 입력해주세요.", success: false)
        } else {
            APIGetManager.shared.checkNickname(nickname: textFieldText) { response,statuscode  in
    //            guard let message = response?.message else { return }
                if statuscode == 200 {
                    self.nickNameCheck = true
                    self.nickNameInputView.setCheckLabel(isHidden: false, text: "사용할 수 있는 닉네임 입니다.", success: true)
                    self.checkEnableNextButton()
                }else {
                    self.nickNameCheck = false
                    self.nickNameInputView.setCheckLabel(isHidden: false, text: "중복된 닉네임입니다.", success: false)
                }
            }
        }
    }
}
extension SignUPSecondProcessVC: SearchMajorSelectCellDelegate{
    func sendSeleceted(major: String) {
        majorInputView.setContentLabelText(text: major)
        checkEnableNextButton()
    }
}
extension SignUPSecondProcessVC: NicknameTextfiledDelegate {
    func endEdit(textFieldText: String) {
        checkEnableNextButton()
        if textFieldText.isEmpty {
            nickNameCheck = false
            self.nickNameInputView.setCheckLabel(isHidden: false, text: "닉네임을 입력해주세요.", success: false)
        }
        
    }
    
    func didBegin() {
        nickNameCheck = false
    }

}
extension SignUPSecondProcessVC: InputViewTextFiledDelegate{
    func ShouldEndEdting(textFieldCount: Int?) {
        if phoneNumberInputView.getTextFieldText().count != 13 {
            self.phoneNumberInputView.setCheckLabel(isHidden: false, text: "올바른 전화번호를 입력해 주세요.", success: false)
            nextButton.isEnabled = false
        } else {
            self.phoneNumberInputView.setCheckLabel(isHidden: true, text: "", success: true)
        }
        checkEnableNextButton()
        
    }
}
