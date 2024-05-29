//
//  MajorInputView.swift
//  GNUting
//
//  Created by 원동진 on 3/19/24.
//

import UIKit


class MajorInputView : UIView{

    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "학과"
        label.font = Pretendard.semiBold(size: 14)
        return label
    }()

    private lazy var contentLabel : UILabel = {
        let textField = UILabel()
        textField.font = Pretendard.regular(size: 12)
        textField.text = "클릭하여 학과를 선택해주세요"
        textField.textColor = UIColor(hexCode: "CBCBCD")

        return textField
    }()
    private let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EAEAEA")
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MajorInputView{
    private func configure(){
        self.addSubViews([titleLabel,contentLabel,bottomLine])
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-14)
        }
    }
}
extension MajorInputView {
    func setContentLabelText(text : String) {
        contentLabel.text = text
        contentLabel.textColor = .black
    }
    func getContentLabelText() -> String?{
        return contentLabel.text
    }
    func isEmpty() -> Bool {
        return contentLabel.text?.count == 0 ? true : false
    }
}
