//
//  NoticeView.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

// MARK: - 공지 사항 View

import UIKit

class NoticeStackView: UIStackView {

    // MARK: - Properties/
    private var labelText: String
    
    // MARK: - SubViews
    
    private lazy var noticeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoudspeakerImg")
        
        return imageView
    }()
    
    private lazy var noticeLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15))
        label.font = Pretendard.regular(size: 11)
        label.textColor = UIColor(hexCode: "4F4F4F")
        label.backgroundColor = UIColor(named: "BackGroundColor")
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }()
    
    // MARK: - Init
    
    init(text: String) {
        self.labelText = text
        super.init(frame: .zero)
        
        setNoticeStackView()
        setAddSubViews()
        setAutoLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NoticeStackView{
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addStackSubViews([noticeImageView, noticeLabel])
    }
    
    private func setAutoLayout() {
        noticeImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    // MARK: - setView
    
    private func setNoticeStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 6
        noticeLabel.text = self.labelText
    }
}
