//
//  DetailDateBoardSetView.swift
//  GNUting
//
//  Created by 원동진 on 2/21/24.
//

import UIKit
protocol DetailDateBoardSetViewButtonAction  : AnyObject {
    func didTapUpDateButton()
    func didTapDeleteButton()
    func didTapReportButton()
}
class DetailDateBoardSetView: UIView {
    weak var buttonActionDelegate : DetailDateBoardSetViewButtonAction?
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.backgroundColor = UIColor(hexCode: "EEEEEE")
        stackView.layer.cornerRadius = 18
        stackView.layer.masksToBounds = true
        return stackView
    }()
    private lazy var borderView1 : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "C5C5C5")
        return view
    }()
    private lazy var updateButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("수정", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 20)!]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 50, bottom: 10, trailing: 50)
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapUpdateButton), for: .touchUpInside)
        return button
    }()
    private lazy var borderView2 : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "C5C5C5")
        return view
    }()
    private lazy var deleteButon : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("삭제", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 20)!]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 50, bottom: 10, trailing: 50)
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    private lazy var reportButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("신고", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 20)!]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 50, bottom: 10, trailing: 50)
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
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
        upperStackView.addStackSubViews([updateButton,borderView1,deleteButon,borderView2,reportButton])
        upperStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [borderView1,borderView2].forEach { borderView in
            borderView.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
    }
}
extension DetailDateBoardSetView{
    @objc private func didTapUpdateButton(){
        buttonActionDelegate?.didTapUpDateButton()
    }
    @objc private func didTapDeleteButton(){
        buttonActionDelegate?.didTapDeleteButton()
    }
    @objc private func didTapReportButton(){
        buttonActionDelegate?.didTapReportButton()
    }
}
