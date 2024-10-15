//
//  HomeTopView.swift
//  GNUting
//
//  Created by 원동진 on 9/5/24.
//

// MARK: - 홈 상단 화면

import UIKit

final class HomeTopView: UIView {
    
    // MARK: - SubViews
    
    private lazy var explainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var imageButton = UIButton()
    
    private lazy var userNameLabel:  UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 22)
        label.numberOfLines = 2
        label.lineBreakStrategy = .hangulWordPriority
        
        return label
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 12)
        label.text = "지누팅에서 아름다운 만남을 가져보세요!"
        label.textColor = UIColor(named: "DisableColor")
        
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 6
        
        return stackView
    }()
    
    let writePostButton = WriteButton()
    let writNoteButton = WriteButton()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setView()
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeTopView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([explainStackView, buttonStackView, imageButton])
        buttonStackView.addStackSubViews([writePostButton,writNoteButton])
        explainStackView.addStackSubViews([userNameLabel, explainLabel])
    }
    
    private func setAutoLayout() {
        explainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalToSuperview().offset(25)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(explainStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalTo(explainStackView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-25)
            make.height.width.equalTo(60)
        }
    }
    
    private func setView() {
        self.backgroundColor = .white
        self.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
    }
    
    private func setButton() {
        writePostButton.setConfiguration(text: "게시글 작성하기", textColor: .white, backgroundColor: UIColor(named: "SecondaryColor") ?? .blue, tag: 0)
        writNoteButton.setConfiguration(text: "메모팅 남기기", textColor: UIColor(hexCode: "191919"), backgroundColor: UIColor(named: "BorderColor") ?? .blue, tag: 1)
    }
}

// MARK: - Internal SubViews Set

extension HomeTopView {
    func setUserNaemLabel(username: String) {
        let text = "\(username) 님 안녕하세요 :)"
        userNameLabel.text = text
        userNameLabel.setRangeTextFont(fullText: text, range: username, font: Pretendard.bold(size: 22) ?? .boldSystemFont(ofSize: 22))
    }
    
    func setImageButton(image: UIImage) {
        DispatchQueue.main.async {
            self.imageButton.setImage(image, for: .normal)
            self.imageButton.layer.cornerRadius = self.imageButton.layer.frame.size.width / 2
            self.imageButton.layer.masksToBounds = true
        }
    }
}
