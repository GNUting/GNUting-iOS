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

final class SettingView: UIView {
    
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
    
    private lazy var updateButton = BoardSettingButton(text: "수정")
    private lazy var deleteButton = BoardSettingButton(text: "삭제")
    private lazy var reportButton = BoardSettingButton(text: "신고")
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setBoardSettingButtonAction()
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
    
    private func setBoardSettingButtonAction() {
        updateButton.addTarget(self, action: #selector(didTapUpdateButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
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
