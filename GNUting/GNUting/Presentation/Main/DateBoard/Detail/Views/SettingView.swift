//
//  DetailDateBoardSetView.swift
//  GNUting
//
//  Created by 원동진 on 2/21/24.
//

// MARK: - ... 세로 클릭시 나타나는 게시글 삭제,수정,신고 기능 View

import UIKit

// MARK: - protocol

protocol OtherPostDelegate: AnyObject {
    func didTapReportButton()
}

protocol MyPostDelegate: AnyObject {
    func didTapUpDateButton()
    func didTapDeleteButton()
}

class SettingView: UIView {
    
    // MARK: - Properties
    
    weak var otherPostDelegate: OtherPostDelegate?
    weak var myPostDelegate: MyPostDelegate?
    
    // MARK: - SubViews
    
    private lazy var upperStackView: UIStackView = {
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
    
    private lazy var borderView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F3F3F3")
        
        return view
    }()
    
    private lazy var updateButton = makeBoardSettingButton(buttonText: "수정", action: #selector(didTapUpdateButton))
    private lazy var deleteButton = makeBoardSettingButton(buttonText: "삭제", action: #selector(didTapDeleteButton))
    private lazy var reportButton = makeBoardSettingButton(buttonText: "신고", action: #selector(didTapReportButton))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddSubViews()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SettingView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubview(upperStackView)
    }
    
    // MARK: - SetView
    
    func setAutoLayout(isMypost: Bool) {
        if isMypost {
            upperStackView.addStackSubViews([updateButton,borderView,deleteButton])
            borderView.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        } else {
            upperStackView.addStackSubViews([reportButton])
        }
        
        upperStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Make
    
    private func makeBoardSettingButton(buttonText : String, action: Selector) -> BoardSettingButton {
        let button = BoardSettingButton()
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setButton(text: buttonText)
        
        return button
    }
    
    // MARK: - Action
    
    @objc private func didTapUpdateButton() {
        myPostDelegate?.didTapUpDateButton()
    }
    
    @objc private func didTapDeleteButton() {
        myPostDelegate?.didTapDeleteButton()
    }
    
    @objc private func didTapReportButton() {
        otherPostDelegate?.didTapReportButton()
    }
}
