//
//  NoticeView.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

// MARK: - 공지 사항 View

import UIKit

final class NoticeStackView: UIView {

    // MARK: - Properties
    
    private var labelText: String
    
    // MARK: - SubViews
    
    private lazy var noticeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoudspeakerImg")
        
        return imageView
    }()
    
    private lazy var noticeLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15),
                                     textColor: UIColor(hexCode: "4F4F4F"),
                                     font: Pretendard.regular(size: 11)!)
        label.backgroundColor = UIColor(named: "BackGroundColor")
        label.setLayerCorner(cornerRaius: 8)
        label.numberOfLines = 2
        
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
        self.addSubViews([noticeImageView, noticeLabel])
    }
    
    private func setAutoLayout() {
        noticeImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(noticeImageView.snp.right).offset(6)
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - setView
    
    private func setNoticeStackView() {
        noticeLabel.text = self.labelText
    }
}
