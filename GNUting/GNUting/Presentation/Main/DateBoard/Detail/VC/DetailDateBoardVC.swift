//
//  DetailDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/20/24.
//

import UIKit

class DetailDateBoardVC: UIViewController {
    var boardID: Int = 0
    var UserInfos: [UserInfosModel] = []
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 20)
        label.textAlignment = .left
        return label
    }()
    private lazy var userInfoView : UserInfoView = {
        let view = UserInfoView()
        return view
    }()
    private lazy var contentTextView : UITextView  = {
        let textView = UITextView()
        textView.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        textView.textColor = .black
        textView.isEditable = false
        textView.text = "안녕하세요!\n저희는 컴퓨터과학과 1학년 4명입니다.\n저희 모두 23학번이구요\n04년생 3명\n03년생 1명 입니다.\n저희랑 재밌게 과팅해요!!!\n편하게 채팅 신청해주세요~"
        return textView
    }()
    private lazy var chatPeopleViewButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("현재채팅/참여중인 사람 4명", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 16)!])) // 수정필요
        config.image = UIImage(named: "ChatImg")
        config.baseForegroundColor = UIColor(named: "PrimaryColor")
        config.imagePlacement = .leading
        config.imagePadding = 5
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapchatPeopleViewButton), for: .touchUpInside)
        return button
    }()
    private lazy var requetChatButton : PrimaryColorButton = { // 어떻게 할지 정해야된다. 내글에서는 필요가 없기때문에
        let button = PrimaryColorButton()
        button.setText("채팅 신청하기")
        button.addTarget(self, action: #selector(tapRequetChatButton), for: .touchUpInside)
        return button
    }()
    private lazy var detailDateBoardSetView : DetailDateBoardSetView = {
        let view = DetailDateBoardSetView()
        view.isHidden = true
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getBoardDetailData()
        addSubViews()
        setAutoLayout()
        bringToDetailDateBoardSetView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
}
extension DetailDateBoardVC{
    private func bringToDetailDateBoardSetView() {
        self.view.bringSubviewToFront(detailDateBoardSetView)
    }
    private func addSubViews() {
        view.addSubViews([titleLabel,userInfoView,contentTextView,chatPeopleViewButton,requetChatButton,detailDateBoardSetView])
    }
    private func setAutoLayout(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        contentTextView.setContentHuggingPriority(.init(249), for: .vertical)
        chatPeopleViewButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        requetChatButton.snp.makeConstraints { make in
            make.top.equalTo(chatPeopleViewButton.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        detailDateBoardSetView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(Spacing.right)
        }
    }
    private func setNavigationBar(){
        setNavigationBar(title: "과팅 게시판")

        let settingButton = UIBarButtonItem(image: UIImage(named: "SettingButton"), style: .plain, target: self, action: #selector(tapSettingButton(_:)))
        settingButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = settingButton
    }
}

// MARK: - Button Action
extension DetailDateBoardVC{
    @objc private func tapSettingButton(_ sender: UIButton){
        sender.isSelected.toggle()
        if sender.isSelected{
            detailDateBoardSetView.isHidden = false
        }else{
            detailDateBoardSetView.isHidden = true
        }
    }
    
    @objc private func didTapchatPeopleViewButton(){
        let vc = DateJoinMemberVC()
        vc.modalPresentationStyle = .fullScreen
        vc.userInfos = self.UserInfos
        self.present(vc, animated: true)
    }
    
    @objc private func tapRequetChatButton(){
        let vc = RequestChatVC()
        vc.boardID = boardID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - detailDateBoardSetViewButton Action Delegate

extension DetailDateBoardVC : OtherPostDelegate {
    func didTapReportButton() { // 신고하기
        let vc = ReportVC()
        vc.boardID = boardID
        detailDateBoardSetView.isHidden = true
        
        self.navigationItem.rightBarButtonItem?.isSelected = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MAKR : 어디서 push 된지 체크

extension DetailDateBoardVC {
    func setPushMypostVersion() {
        detailDateBoardSetView.myPost(isMypost: true)
    }
    func setPushBoardList() {
        detailDateBoardSetView.otherPostDelegate = self
        detailDateBoardSetView.myPost(isMypost: false)
    }
}

extension DetailDateBoardVC {
    private func getBoardDetailData() {
        
        APIGetManager.shared.getBoardDetail(id: boardID) { boardDetailData in
            guard let result = boardDetailData?.result else { return }
            let user = result.user
            
            self.titleLabel.text =  result.title
            self.contentTextView.text = result.detail
            self.UserInfos = result.inUser
            self.userInfoView.setUserInfoView(userImage: user.image, userNickname: user.nickname, major: user.department, StudentID: user.studentId, writeDataeLabel: result.time)
        }
    }
}
