//
//  TotalAlertVC.swift
//  GNUting
//
//  Created by 원동진 on 5/4/24.
//

import UIKit

class TotalAlertVC: UIViewController {
    
    private lazy var bellImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AlertSetImage")
        return imageView
    }()
    private lazy var labelStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 3
        return stackView
    }()
    private lazy var firstExplainLabel: UILabel = {
        let label = UILabel()
        let text = "기기 설정 내 지누팅 알림을 꼭! 허용해 주세요"
        label.text = text
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 13)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryCOlor") ?? .red, range: (text as NSString).range(of: "지누팅 알림"))
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryCOlor") ?? .red, range: (text as NSString).range(of: "꼭! 허용"))
        label.attributedText = attributedString
        return label
    }()
    private lazy var secondExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "해당 설정이 꺼져있으면 알림을 받을 수 없습니다.\n기기 설정에서 지누팅 알림 허용 여부를 확인해 주세요."
        label.numberOfLines = 2
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 11)
        return label
    }()
    private lazy var borderView = BorderView()
    private lazy var agreePushNotiLabel : UILabel = {
       let label = UILabel()
        label.text = "앱 푸시 알림 동의"
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 13)
        
        return label
    }()
    
    private lazy var alertAllowButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "OnToggleImage"), for: .normal)
        button.addTarget(self, action: #selector(tapAlertAllowButton(_ :)), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar()
    }
    
}
extension TotalAlertVC{
    private func setNavigationBar() {
        setNavigationBar(title: "알림 설정")
        self.navigationController?.navigationBar.isHidden = false
    }
    private func setAddSubViews() {
        view.addSubViews([bellImageView,labelStackView,borderView,agreePushNotiLabel,alertAllowButton])
        labelStackView.addStackSubViews([firstExplainLabel,secondExplainLabel])
    }
    private func setAutoLayout(){
        bellImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.left.equalToSuperview().offset(43)
            
        }
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(bellImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-43)
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(25)
        }
        agreePushNotiLabel.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(25)
        }
        alertAllowButton.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(25)
            make.left.greaterThanOrEqualTo(agreePushNotiLabel.snp.right).offset(30)
            make.right.equalToSuperview().offset(-25)
        }
    }
    
}

extension TotalAlertVC {
    @objc private func tapAlertAllowButton(_ sender: UIButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            APIPutManager.shared.putTotalNotification(alertStatus: AlertState.enable.status) { response in
                if response.isSuccess {
                    sender.setImage(UIImage(named: "OnToggleImage"), for: .normal)
                    
                } else {
                    self.errorHandling(response: response)
                }
                
            }
        } else {
            APIPutManager.shared.putTotalNotification(alertStatus: AlertState.disable.status) { response in
                if response.isSuccess {
                    sender.setImage(UIImage(named: "OffToggleImage"), for: .normal)
                    
                } else {
                    self.errorHandling(response: response)
                }
            }
            
        }
                
    }
}
