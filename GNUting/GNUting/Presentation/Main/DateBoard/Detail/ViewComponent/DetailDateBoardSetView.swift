//
//  DetailDateBoardSetView.swift
//  GNUting
//
//  Created by 원동진 on 2/21/24.
//

import UIKit
protocol OtherPostDelegate: AnyObject {

    func didTapReportButton()
}
protocol MyPostDelegate: AnyObject {
    func didTapUpDateButton()
    func didTapDeleteButton()
}


class DetailDateBoardSetView: UIView {
    weak var otherPostDelegate : OtherPostDelegate?
    weak var MyPostDelegate : MyPostDelegate?
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    private lazy var borderView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F3F3F3")
        return view
    }()
    private lazy var updateButton : BoardSettingButton = {
        let button = BoardSettingButton()
        button.setButton(text: "수정")
        button.addTarget(self, action: #selector(didTapUpdateButton), for: .touchUpInside)
        
        return button
    }()
    private lazy var deleteButon : BoardSettingButton = {
        let button = BoardSettingButton()
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.setButton(text: "삭제")
        return button
    }()
    private lazy var reportButton : BoardSettingButton = {
        let button = BoardSettingButton()
        button.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
        button.setButton(text: "신고")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension DetailDateBoardSetView{
    private func configure() {
        self.addSubview(upperStackView)
    }
}
extension DetailDateBoardSetView{
    @objc private func didTapUpdateButton(){
        MyPostDelegate?.didTapUpDateButton()
    }
    @objc private func didTapDeleteButton(){
        MyPostDelegate?.didTapDeleteButton()
    }
    @objc private func didTapReportButton(){
        otherPostDelegate?.didTapReportButton()
    }
}

extension DetailDateBoardSetView {
    func myPost(isMypost: Bool) {
        if isMypost {
            upperStackView.addStackSubViews([updateButton,borderView,deleteButon])
            upperStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            borderView.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        } else {
            upperStackView.addStackSubViews([reportButton])
            upperStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
       
    }
}
