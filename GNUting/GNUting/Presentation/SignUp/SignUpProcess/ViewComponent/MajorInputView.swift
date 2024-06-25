//
//  MajorInputView.swift
//  GNUting
//
//  Created by 원동진 on 3/19/24.
//

// MARK: - 학과 선택 InputView 회원가입, 닉네임 수정 View

import UIKit

final class MajorInputView: UIView {
    
    // MARK: - SubViews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "학과"
        label.font = Pretendard.semiBold(size: 14)
        
        return label
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 12)
        label.text = "클릭하여 학과를 선택해주세요"
        label.textColor = UIColor(hexCode: "CBCBCD")

        return label
    }()
    
    private let borderView = BorderView()
    
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

// MARK: - Layout Helpers

extension MajorInputView {
    private func setAddSubViews() {
        self.addSubViews([titleLabel, contentLabel, borderView])
    }
    
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
    }
}

// MARK: - Method public

extension MajorInputView {
    public func setContentLabelText(text: String) {
        contentLabel.text = text
        contentLabel.textColor = .black
    }
    
    public func getContentLabelText() -> String? {
        return contentLabel.text
    }
    
    public func isEmpty() -> Bool {
        return contentLabel.text?.count == 0 ? true : false
    }
}
