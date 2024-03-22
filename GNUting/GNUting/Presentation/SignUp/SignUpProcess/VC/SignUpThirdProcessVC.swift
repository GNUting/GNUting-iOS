//
//  SighUpThirdProcessVC.swift
//  GNUting
//
//  Created by 원동진 on 2/11/24.
//

import UIKit
import SnapKit
import PhotosUI

class SignUpThirdProcessVC: UIViewController {
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhothImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    private let explainLabel : UILabel = {
        let uiLabel = UILabel()
        let fullText = "아이콘을 눌러\n회원님의 프로필 사진을 등록해주세요."
        uiLabel.numberOfLines = 2
        uiLabel.textAlignment = .center
        uiLabel.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        uiLabel.text = fullText
        uiLabel.setRangeTextFont(fullText: fullText, range: "프로필 사진", uiFont: UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!)
        return uiLabel
    }()
    private lazy var signUpCompltedButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("가입 완료")
        button.addTarget(self, action: #selector(tapSignUpCompltedButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar(title: "3/3")
        addSubViews()
        setAutoLayout()
    }
    
}
extension SignUpThirdProcessVC{
    private func addSubViews(){
        self.view.addSubViews([phothImageView,explainLabel,signUpCompltedButton])
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
        signUpCompltedButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

extension SignUpThirdProcessVC {
    private func setPostData() {
        let savedSignUpdate = SignUpModelManager.shared.signUpDictionary
        
        let signUpData : SignUpModel = SignUpModel(birthDate: savedSignUpdate["birthDate"] ?? "", department: savedSignUpdate["department"] ?? "", email: (savedSignUpdate["email"] ?? "") + "@gnu.ac.kr", gender: savedSignUpdate["gender"] ?? "", name: savedSignUpdate["name"] ?? "", nickname: savedSignUpdate["nickname"] ?? "", password: savedSignUpdate["password"] ?? "", phoneNumber: savedSignUpdate["phoneNumber"] ?? "", studentId: savedSignUpdate["studentId"] ?? "", userSelfIntroduction: savedSignUpdate["userSelfIntroduction"] ?? "")
        var image = phothImageView.image
        if image == UIImage(named: "photoImg") {
            image = nil
        }
        APIPostManager.shared.postSignUP(signUpdata: signUpData, image: image ?? UIImage()) { response  in
            if response.isSuccess {
                self.loginAPI()
            } else {
                self.errorHandling(response: response)
                self.navigationController?.setViewControllers([AppStartVC()], animated: true)
            }
        }
    }
}

extension SignUpThirdProcessVC {
    
    @objc private func tapSignUpCompltedButton(){
        setPostData()
  
        
    }
    
    @objc private func tapPhothImageView() {
        present(imagePicker,animated: true)
    }
    func loginAPI() {
        let savedSignUpdate = SignUpModelManager.shared.signUpDictionary
        guard let email = savedSignUpdate["email"] else { return }
        guard let password = savedSignUpdate["password"] else { return }
        let alert = UIAlertController(title: "가입 완료", message: "가입이 완료 되었습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            APIPostManager.shared.postLoginAPI(email: email, password: password) { response,successResponse  in
                if response?.isSuccess == false {
                    self.errorHandling(response: response)
                    KeyChainManager.shared.create(key: "email", token: email)
                    UserDefaultsManager.shared.setLogin()
                 
                }
                if successResponse?.isSuccess == true {
                    self.view.window?.rootViewController = TabBarController()
                }
            }
        }))
       
       
        self.present(alert, animated: true)
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
                }
            }
            
        }
    }
}
