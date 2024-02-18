//
//  SignUPSecondProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import UIKit

class SignUPSecondProcessVC: UIViewController {
    var selectedDate : String = ""
    private lazy var inputViewUpperStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var nameInputView : SignUPInpuView = {
       let signUPInpuView = SignUPInpuView()
        signUPInpuView.setInputTextTypeLabel(text: "이름")
        signUPInpuView.setPlaceholder(placeholder: "이름을 입력해주세요.")
        return signUPInpuView
    }()
    private lazy var phoneNumberInputView : SignUPInpuView = {
       let signUPInpuView = SignUPInpuView()
        signUPInpuView.setInputTextTypeLabel(text: "전화번호")
        signUPInpuView.setPlaceholder(placeholder: "전화번호를 입력해주세요.")
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
        datePicker.preferredDatePickerStyle = .inline
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
    private lazy var nickNameInputView : SignUPInpuView = {
       let nickNameInputView = SignUPInpuView()
        nickNameInputView.setInputTextTypeLabel(text: "닉네임")
        nickNameInputView.setPlaceholder(placeholder: "닉네임을 입력해주세요.")
        return nickNameInputView
    }()
    private lazy var majorInputView : SignUPInpuView = {
       let majorInputView = SignUPInpuView()
        majorInputView.setInputTextTypeLabel(text: "학과")
        majorInputView.setPlaceholder(placeholder: "힉과를 입력해주세요.")
        return majorInputView
    }()
    private lazy var studentIDInputView : SignUPInpuView = {
       let studentIDInputView = SignUPInpuView()
        studentIDInputView.setInputTextTypeLabel(text: "학번")
        studentIDInputView.setPlaceholder(placeholder: "학번을 입력해주세요.")
        return studentIDInputView
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

}
extension SignUPSecondProcessVC{
    private func addSubViews(){
        self.view.addSubViews([inputViewUpperStackView,datePicker,bluerEffectView,buttonStackView,nextButton])
        inputViewUpperStackView.addStackSubViews([nameInputView,phoneNumberInputView,genderView,selectDateView,nickNameInputView,majorInputView,studentIDInputView])
        buttonStackView.addStackSubViews([dateViewCacnelButton,dateViewSelectButton])
    }
    private func setAutoLayout(){
        inputViewUpperStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        datePicker.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom)
            make.centerX.equalToSuperview()
            
        }
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
    private func setNavigationBar(){
        let backButton = BackButton()
        backButton.setConfigure(text: "")
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        let popButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = popButton
        self.navigationItem.title = "2/3"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
    }
}
extension SignUPSecondProcessVC {
    @objc private func tapSelectDateView(){
        datePicker.isHidden = false
        buttonStackView.isHidden = false
        view.bringSubviewToFront(datePicker)
        view.bringSubviewToFront(buttonStackView)
        bluerEffectView.alpha = 1
    }
    @objc private func changeDate(_ sender : UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        selectedDate = formatter.string(from: sender.date)
        
    
    }
    @objc private func tapSelectButton(){
        datePicker.isHidden = true
        buttonStackView.isHidden = true
        bluerEffectView.alpha = 0
        let dateArr = selectedDate.split(separator: " ").map{String($0)}
        selectDateView.setDateLabel(date: DateModel(year: dateArr[0], momth: dateArr[1], day: dateArr[2]))
        
    }
    @objc private func tapCanelButton(){
        datePicker.isHidden = true
        buttonStackView.isHidden = true
        bluerEffectView.alpha = 0
        
    }
    @objc private func tapNextButton(){
        let vc = SighUpThirdProcessVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
