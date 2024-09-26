//
//  HomeBottomView.swift
//  GNUting
//
//  Created by 원동진 on 9/5/24.
//

// MARK: 홈 하단 화면

import UIKit

// MARK: - Protocol

protocol HomeBottomViewDelegate: AnyObject {
    func tapPostBoardCardView()
    func oneMatchCardView()
    func tapMypostCardView()
    func tapNoteCardView()
    func tapEventButton()
}

final class HomeBottomView: UIView {
    
    // MARK: - Properties
    
    weak var homeBottomViewDelegate: HomeBottomViewDelegate?
    
    // MARK: - SubViews
    
    private let eventButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "EventBannerImage"), for: .normal)
        
        return button
    }()
    
    private let postSubView: ImagePlusLabelView = {
        let view = ImagePlusLabelView()
        view.setImagePlusLabelView(imageName: "PostImage", textFont: Pretendard.bold(size: 16) ?? .boldSystemFont(ofSize: 16), labelText: "모든 글은 여기서 볼 수 있어요")
        
        return view
    }()
    
    let firstCardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    let seoncdCardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private lazy var postBoardCardView = makeCardImaegButton(image: UIImage(named: "PostBoardCardImage") ?? UIImage(), action: #selector(tapPostBoardCardView))
    private lazy var OneMatchCardView = makeCardImaegButton(image: UIImage(named: "OneMatchCardImage") ?? UIImage(), action: #selector(tapOneMatchCardView))
    private lazy var noteCardView = makeCardImaegButton(image: UIImage(named: "NoteCardImage") ?? UIImage(), action: #selector(tapNoteCardView))
    private lazy var mypostCardView = makeCardImaegButton(image: UIImage(named: "MypostCardImage") ?? UIImage(), action: #selector(tapPostBoardCardView))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        eventButton.addTarget(self, action: #selector(tapEventButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeBottomView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([eventButton,postSubView, firstCardStackView, seoncdCardStackView])
        firstCardStackView.addStackSubViews([postBoardCardView, OneMatchCardView])
        seoncdCardStackView.addStackSubViews([noteCardView, mypostCardView])
    }
    
    private func setAutoLayout(){
        eventButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(25)
        }
        
        postSubView.snp.makeConstraints { make in
            make.top.equalTo(eventButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(25)
        }
        
        firstCardStackView.snp.makeConstraints { make in
            make.top.equalTo(postSubView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(25)
            
        }
        
        seoncdCardStackView.snp.makeConstraints { make in
            make.top.equalTo(firstCardStackView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Private Method
    
    private func makeCardImaegButton(image: UIImage, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
}

// MARK: - action

extension HomeBottomView {
    @objc private func tapPostBoardCardView() {
        homeBottomViewDelegate?.tapPostBoardCardView()
    }
    
    @objc private func tapOneMatchCardView() {
        homeBottomViewDelegate?.oneMatchCardView()
    }
    
    @objc private func tapMypostCardView() {
        homeBottomViewDelegate?.tapMypostCardView()
    }
    
    @objc private func tapNoteCardView() {
        homeBottomViewDelegate?.tapNoteCardView()
    }
    
    @objc private func tapEventButton() {
        homeBottomViewDelegate?.tapEventButton()
    }
}
