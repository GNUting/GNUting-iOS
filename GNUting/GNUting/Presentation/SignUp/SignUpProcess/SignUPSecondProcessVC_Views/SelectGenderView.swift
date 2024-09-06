//
//  SelectGenderView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

// MARK: - 회원가입 (2) 성별 선택 View

import UIKit

final class SelectGenderView: UIView {
    
    // MARK: - Properties
    
    private var selectedGender: Int = 0 // 0 : 남자 , 1:여자

    // MARK: - SubViews
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = Pretendard.semiBold(size: 14)
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var manTypeButton = makeGenderButton(title: "남", tag: 0)
    private lazy var girlTypeButton = makeGenderButton(title: "여", tag: 1)
  
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Method

extension SelectGenderView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([typeLabel, buttonStackView])
        buttonStackView.addStackSubViews([manTypeButton, girlTypeButton])
    }
    
    private func setAutoLayout() {
        typeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
    }
    
    // MARK: - Make GenderButton
    
    private func makeGenderButton(title: String, tag: Int) -> GenderButton {
        let genderButton = GenderButton()
        genderButton.setGenderButton(title: title, tag: tag)
        genderButton.genderButtonDelegate = self
        
        return genderButton
    }
    
    // MARK: - Internal

    func getSelectedGender() -> String {
        return selectedGender == 0 ? "MALE" : "FEMALE"
    }
}

// MARK: - Delegate

extension SelectGenderView: GenderButtonDelegate {
    func tapButtonAction(tag: Int) {
        self.selectedGender = tag
        
        if tag == 0 {
            manTypeButton.isSelected = true
            girlTypeButton.isSelected = false
        } else {
            manTypeButton.isSelected = false
            girlTypeButton.isSelected = true
        }
    }
}
