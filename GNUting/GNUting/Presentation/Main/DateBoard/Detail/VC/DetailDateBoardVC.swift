//
//  DetailDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/20/24.
//

import UIKit

class DetailDateBoardVC: BaseViewController{
    var boardID: Int = 0
    var userInfos: [UserInfosModel] = []
    var postUserInfos : User?
    var chatMemeberCount: Int = 0
    private lazy var statusLabel : UILabel = {
       let label = UILabel()
        label.text = "신청 가능"
        label.font = Pretendard.semiBold(size: 14)
        label.textColor = UIColor(named: "SecondaryColor")
        return label
    }()
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 16)
        label.textAlignment = .left
        
        return label
    }()
    private lazy var writeDateLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Pretendard.regular(size: 14)
        label.textColor = UIColor(named: "DisableColor")
        return label
    }()
    private lazy var userInfoView : UserInfoView = {
        let view = UserInfoView()
        view.userImageButton.userImageButtonDelegate = self
        return view
    }()
    private lazy var contentTextView : UITextView  = {
        let textView = UITextView()
        textView.font = Pretendard.regular(size: 18)
        textView.textColor = .black
        textView.isEditable = false

        return textView
    }()
    private lazy var chatPeopleViewButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapchatPeopleViewButton), for: .touchUpInside)
        return button
    }()
    private lazy var requetChatButton : PrimaryColorButton = { // 어떻게 할지 정해야된다. 내글에서는 필요가 없기때문에
        let button = PrimaryColorButton()
        button.setText("신청하기",fointSize: 16)
        button.addTarget(self, action: #selector(tapRequetChatButton(_ :)), for: .touchUpInside)
        return button
    }()
    private lazy var detailDateBoardSetView : DetailDateBoardSetView = {
        let view = DetailDateBoardSetView()
        view.isHidden = true

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.1
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        bringToDetailDateBoardSetView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBoardDetailData()
        setNavigationBar()
    }
}
extension DetailDateBoardVC{
    private func bringToDetailDateBoardSetView() {
        self.view.bringSubviewToFront(detailDateBoardSetView)
    }
    private func addSubViews() {
        view.addSubViews([statusLabel, titleLabel, writeDateLabel, userInfoView, contentTextView, chatPeopleViewButton, requetChatButton, detailDateBoardSetView])
    }
    private func setAutoLayout(){
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
            
        }
        writeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(writeDateLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
        }
        contentTextView.setContentHuggingPriority(.init(249), for: .vertical)
        chatPeopleViewButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        requetChatButton.snp.makeConstraints { make in
            make.top.equalTo(chatPeopleViewButton.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
            
        }
        detailDateBoardSetView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(Spacing.right)
        }
    }
    private func setNavigationBar(){
        

        let settingButton = UIBarButtonItem(image: UIImage(named: "SettingButton"), style: .plain, target: self, action: #selector(tapSettingButton(_:)))
        settingButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = settingButton
    }
    private func setChatPeopleViewButton(memeberCount: Int) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("과팅 멤버 정보 \(memeberCount)명", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 15) ?? .systemFont(ofSize: 15)]))
        config.image = UIImage(named: "ChatImg")
        config.baseForegroundColor = UIColor(named: "PrimaryColor")
        config.imagePlacement = .leading
        config.imagePadding = 5
        chatPeopleViewButton.configuration = config
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
        vc.userInfos = self.userInfos
        self.present(vc, animated: true)
    }
    
    @objc private func tapRequetChatButton(_ sender: UIButton){
        guard let buttonText = sender.titleLabel?.text else { return }
        if buttonText == "신청하기" {
            let vc = RequestChatVC()
            vc.boardID = boardID
            vc.chatMemeberCount = self.chatMemeberCount
            pushViewContoller(viewController: vc)
        } else {
            self.tabBarController?.selectedIndex = 1
        }
        
    }
}

// MARK: - detailDateBoardSetViewButton Action Delegate

extension DetailDateBoardVC : OtherPostDelegate {
    func didTapReportButton() { // 신고하기
        let vc = ReportVC()
        
        self.navigationItem.rightBarButtonItem?.isSelected = false
        vc.boardID = boardID
        detailDateBoardSetView.isHidden = true
        presentFullScreenVC(viewController: vc)
    }
}
extension DetailDateBoardVC: MyPostDelegate {
    func didTapUpDateButton() {
        detailDateBoardSetView.isHidden = true
        let vc = UpdatePostVC()
        vc.setPostTestView(title: titleLabel.text ?? "", content: contentTextView.text)
        vc.boardID = boardID
        vc.memberDataList = userInfos
        pushViewContoller(viewController: vc)
    }
    
    func didTapDeleteButton() {
    
        let alertController = UIAlertController(title: "", message: "게시글을 삭제하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive))
        alertController.addAction(UIAlertAction(title: "예", style: .default,handler: { _ in
            APIDeleteManager.shared.deletePostText(boardID: self.boardID) { response in
                if response.isSuccess {
                    self.showMessagePop(message: "게시글이 삭제되었습니다.")
                } else {
                    self.errorHandling(response: response)
                }
            }
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
        
        
    }
}
// MAKR : 어디서 push 된지 체크

extension DetailDateBoardVC {
    func setPushMypostVersion() {
        setNavigationBar(title: "내가 쓴 게시글")
        requetChatButton.backgroundColor = UIColor(named: "SecondaryColor")
        requetChatButton.setText("신청 현황 보러가기",fointSize: 16)
        chatPeopleViewButton.isHidden = true
        detailDateBoardSetView.myPost(isMypost: true)
        detailDateBoardSetView.MyPostDelegate = self
    }
    func setPushBoardList() {
        setNavigationBar(title: "과팅 게시판")
        detailDateBoardSetView.otherPostDelegate = self
        detailDateBoardSetView.myPost(isMypost: false)
    }
}

extension DetailDateBoardVC {
    private func getBoardDetailData() {
        
        APIGetManager.shared.getBoardDetail(id: boardID) { boardDetailData,response  in
            self.errorHandling(response: response)
            guard let result = boardDetailData?.result else { return }
            let user = result.user
           
            self.postUserInfos = user
            self.titleLabel.text =  result.title
            self.writeDateLabel.text = result.time
            self.contentTextView.text = result.detail
            self.userInfos = result.inUser
            self.userInfoView.setUserInfoView(userImage: user.image, userNickname: user.nickname, major: user.department, StudentID: user.studentId)
    
            self.setChatPeopleViewButton(memeberCount: result.inUser.count)
            self.chatMemeberCount = result.inUser.count
            if result.status == "OPEN" {
                self.statusLabel.textColor = UIColor(named: "SecondaryColor")
                self.statusLabel.text = "신청 가능"
            } else {
                self.statusLabel.textColor = UIColor(named: "PrimaryColor")
                self.statusLabel.text = "신청 마감"
                
            }
            
        }
    }
}
extension DetailDateBoardVC: UserImageButtonDelegate {
    func tappedAction() {
        let vc = UserDetailVC()
        vc.userNickname = postUserInfos?.nickname
        vc.imaegURL = postUserInfos?.image
        vc.userDepartment = postUserInfos?.department
        vc.userStudentID = postUserInfos?.studentId
        presentFullScreenVC(viewController: vc)
    }
    
    
}
