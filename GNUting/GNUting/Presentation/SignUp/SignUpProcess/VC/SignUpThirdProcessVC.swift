//
//  SighUpThirdProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/11/24.
//

// MARK: - 회원가입 2 단계 ViewController

import UIKit
import SnapKit
import PhotosUI

class SignUpThirdProcessVC: BaseViewController {
    
    // MARK: - SubViews
    
    private lazy var phpickerConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images,.livePhotos])
        configuration.selectionLimit = 1
        
        return configuration
    }()
    
    private lazy var imagePicker: PHPickerViewController = {
        let imaegPicker = PHPickerViewController(configuration: phpickerConfiguration)
        imaegPicker.delegate = self
        
        return imaegPicker
    }()
    
    private lazy var photoImageView : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photoImg"), for: .normal)
        
        return button
    }()
    
    private let explainLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Pretendard.bold(size: 22)
        label.text =  "거의 다왔어요!\n프로필 사진을 등록해주세요:)"
        
        return label
    }()
    
    private lazy var imageSkipButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapSignUpCompltedButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bottomButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("프로필 사진 등록하기")
        button.addTarget(self, action: #selector(tapBottomButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarSignUpProcess(imageName: "SignupImage3")
        addSubViews()
        setAutoLayout()
        setImageSkipButton()
        setExplainLabel()
    }
}

// MARK: - Method

extension SignUpThirdProcessVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        self.view.addSubViews([photoImageView, explainLabel, imageSkipButton, bottomButton])
    }
    
    private func setAutoLayout() {
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(2.0/3.0)
            make.height.width.equalTo(150)
        }
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        imageSkipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top).offset(-12)
        }
        bottomButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    // MARK: - SetView
    
    private func setImageSkipButton() {
        let text = "나중에 할게요"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        attributeString.addAttribute(.font , value: Pretendard.regular(size: 14) ?? .systemFont(ofSize: 14), range: NSRange.init(location: 0, length: text.count))
        attributeString.addAttribute(.foregroundColor, value: UIColor(hexCode: "979C9E"), range: NSRange.init(location: 0, length: text.count))
        imageSkipButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func setExplainLabel() {
        guard let text = explainLabel.text else { return }
        let range = (text as NSString).range(of: "프로필 사진")
        let attribtuedString = NSMutableAttributedString(string: text)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryColor") ?? .red, range: range)
        explainLabel.attributedText = attribtuedString
    }
    private func setAlertController() {
        let alertController = UIAlertController(title: "회원가입 성공", message: "로그인을 진행하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive,handler: { _ in
            self.navigationController?.setViewControllers([LoginVC()], animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
            self.loginAPI()
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    // MARK: - Data Processing
    
    private func setAndPostSignUp() {
        let savedSignUpdate = SignUpModelManager.shared.signUpDictionary
        let signUpData : SignUpModel = SignUpModel(birthDate: savedSignUpdate["birthDate"] ?? "",
                                                   department: savedSignUpdate["department"] ?? "",
                                                   email: (savedSignUpdate["email"] ?? "") + "@gnu.ac.kr",
                                                   gender: savedSignUpdate["gender"] ?? "",
                                                   name: savedSignUpdate["name"] ?? "",
                                                   nickname: savedSignUpdate["nickname"] ?? "",
                                                   password: savedSignUpdate["password"] ?? "",
                                                   phoneNumber: savedSignUpdate["phoneNumber"] ?? "",
                                                   studentId: savedSignUpdate["studentId"] ?? "",
                                                   userSelfIntroduction: savedSignUpdate["userSelfIntroduction"] ?? "")
        var image = photoImageView.imageView?.image
        if image == UIImage(named: "photoImg") {
            image = nil
        }
        
        postSignUPAPI(signUpdata: signUpData, image: image)
    }
    
    // MARK: - API
    
    private func loginAPI() {
        let savedSignUpdate = SignUpModelManager.shared.signUpDictionary
        guard let email = savedSignUpdate["email"] else { return }
        guard let password = savedSignUpdate["password"] else { return }
        
        APIPostManager.shared.postLoginAPI(email: email+"@gnu.ac.kr", password: password) { response,successResponse  in
            if response?.isSuccess == false {
                self.errorHandling(response: response)
            }
            if successResponse?.isSuccess == true {
                self.view.window?.rootViewController = TabBarController()
            }
        }
    }
    
    private func postSignUPAPI(signUpdata: SignUpModel, image: UIImage? ) {
        APIPostManager.shared.postSignUP(signUpdata: signUpdata, image: image) { response  in
            if response.isSuccess {
                self.setAlertController()
            } else {
                self.errorHandling(response: response)
                self.navigationController?.setViewControllers([LoginVC()], animated: true)
            }
        }
    }
}

// MARK: - Delegate

extension SignUpThirdProcessVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (image,error) in
                DispatchQueue.main.async {
                    self.photoImageView.layer.cornerRadius = 75
                    self.photoImageView.layer.masksToBounds = true
                    self.photoImageView.setImage(image as? UIImage, for: .normal)
                    self.imageSkipButton.isHidden = true
                    self.bottomButton.setText("지누팅 시작하기")
                }
            }
        }
    }
}

// MARK: - Action

extension SignUpThirdProcessVC {
    @objc private func tapSignUpCompltedButton(){
        setAndPostSignUp()
    }
    
    @objc private func tapBottomButton() {
        if bottomButton.titleLabel?.text == "프로필 사진 등록하기" {
            present(imagePicker, animated: true)
        } else {
            setAndPostSignUp()
        }
    }
}
