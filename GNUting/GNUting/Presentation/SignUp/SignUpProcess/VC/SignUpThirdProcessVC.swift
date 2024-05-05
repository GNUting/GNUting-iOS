//
//  SighUpThirdProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/11/24.
//

import UIKit
import SnapKit
import PhotosUI

class SignUpThirdProcessVC: BaseViewController {
    //    var imageFileName : String = ""
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
    
    private lazy var phothImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photoImg")
        imageView.contentMode = .scaleToFill
  
        return imageView
    }()
    private let explainLabel : UILabel = {
        let label = UILabel()
        let text = "거의 다왔어요!\n프로필 사진을 등록해주세요:)"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 22)
        label.text = text
        let range = (text as NSString).range(of: "프로필 사진")
        let attribtuedString = NSMutableAttributedString(string: text)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryColor") ?? .red, range: range)
        label.attributedText = attribtuedString
        return label
    }()
    private lazy var imageSkipButton: UIButton = {
        let button = UIButton()
        let text = "나중에 할게요"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        attributeString.addAttribute(.font , value: UIFont(name: Pretendard.Regular.rawValue, size: 14) ?? .systemFont(ofSize: 14), range: NSRange.init(location: 0, length: text.count))
        attributeString.addAttribute(.foregroundColor, value: UIColor(hexCode: "979C9E"), range: NSRange.init(location: 0, length: text.count))
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(tapSignUpCompltedButton), for: .touchUpInside)
        return button
    }()
    private lazy var bottomButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("프로필 사진 등록하기")
        button.addTarget(self, action: #selector(tapBottomButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarSignUpProcess(imageName: "SignupImage3")
        addSubViews()
        setAutoLayout()
    }
    
}
extension SignUpThirdProcessVC{
    private func addSubViews(){
        self.view.addSubViews([phothImageView,explainLabel,imageSkipButton,bottomButton])
    }
    private func setAutoLayout(){
        phothImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(2.0/3.0)
            make.height.width.equalTo(150)
        }
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(phothImageView.snp.bottom).offset(30)
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
}

extension SignUpThirdProcessVC {
    private func setAndPostSignUp() {
        let savedSignUpdate = SignUpModelManager.shared.signUpDictionary
        
        let signUpData : SignUpModel = SignUpModel(birthDate: savedSignUpdate["birthDate"] ?? "", department: savedSignUpdate["department"] ?? "", email: (savedSignUpdate["email"] ?? "") + "@gnu.ac.kr", gender: savedSignUpdate["gender"] ?? "", name: savedSignUpdate["name"] ?? "", nickname: savedSignUpdate["nickname"] ?? "", password: savedSignUpdate["password"] ?? "", phoneNumber: savedSignUpdate["phoneNumber"] ?? "", studentId: savedSignUpdate["studentId"] ?? "", userSelfIntroduction: savedSignUpdate["userSelfIntroduction"] ?? "")
        var image = phothImageView.image
        if image == UIImage(named: "photoImg") {
            image = nil
        }
    
        APIPostManager.shared.postSignUP(signUpdata: signUpData, image: image ?? UIImage()) { response  in
            if response.isSuccess {
                let alertController = UIAlertController(title: "회원가입 성공", message: "로그인을 진행하시겠습니까?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "아니요", style: .cancel,handler: { _ in
                    self.navigationController?.setViewControllers([LoginVC()], animated: true)
                }))
                alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
                    self.loginAPI()
                }))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            } else {
                self.errorHandling(response: response)
                self.navigationController?.setViewControllers([LoginVC()], animated: true)
            }
        }
    }
}

extension SignUpThirdProcessVC {
    @objc private func tapSignUpCompltedButton(){
        setAndPostSignUp()
    }
    
    @objc private func tapBottomButton() {
        if bottomButton.titleLabel?.text == "프로필 사진 등록하기" {
            present(imagePicker,animated: true)
        } else {
            setAndPostSignUp()
        }
    }
    func loginAPI() {
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
}


extension SignUpThirdProcessVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (image,error) in
                DispatchQueue.main.async {
                    self.phothImageView.layer.cornerRadius = 75
                    self.phothImageView.layer.masksToBounds = true
                    self.phothImageView.image = image as? UIImage
                    self.imageSkipButton.isHidden = true
                    self.bottomButton.setText("지누팅 시작하기")
                    
                }
            }
            
        }
    }
}
