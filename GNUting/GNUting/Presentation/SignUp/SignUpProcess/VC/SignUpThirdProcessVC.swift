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
        
//        let signUpData : SignUpModel = SignUpModel(birthDate: savedSignUpdate["birthDate"] ?? "", department: savedSignUpdate["department"] ?? "", email: (savedSignUpdate["email"] ?? "") + "@gnu.ac.kr", gender: savedSignUpdate["gender"] ?? "", name: savedSignUpdate["name"] ?? "", nickname: savedSignUpdate["nickname"] ?? "", password: savedSignUpdate["password"] ?? "", phoneNumber: savedSignUpdate["phoneNumber"] ?? "", studentId: savedSignUpdate["studentId"] ?? "", userSelfIntroduction: savedSignUpdate["userSelfIntroduction"] ?? "")
//        let signUpData : SignUpModel = SignUpModel(birthDate: "1997-06-11", department: "컴퓨터과학과", email: "tjsqls8337@gnu.ac.kr", gender: "MALE", name: "원동진", nickname: "동진97", password: "123456", phoneNumber: "01041964507", studentId: "2016010879", userSelfIntroduction: "테스트아이디")
    
//        APIPostManager.shared.postSignUP(signUpdata: signUpData, image: phothImageView.image ?? UIImage()) { error in
//            guard error != nil else {
//                print("Error :\(String(describing: error))")
//                return
//            }
    
//        }
    }
}

extension SignUpThirdProcessVC {
    
    @objc private func tapSignUpCompltedButton(){
        let alert = UIAlertController(title: "가입 완료", message: "가입이 완료 되었습니다", preferredStyle: .alert)
        setPostData()
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            let vc = LoginVC()
            self.navigationController?.setViewControllers([AppStartVC()], animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    
    @objc private func tapPhothImageView() {
        present(imagePicker,animated: true)
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
        } else {
            
        }
        
    }
}

