//
//  NoteViewController.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

// MARK: - 메모팅 VC

import UIKit

final class NoteViewController: BaseViewController {
    
    // MARK: - Properties
    
    let textViewPlaceHolder = "내용을 입력해주세요."
    var selectedNoteID : Int?
    private var noteInformation: NoteGetModel? {
        didSet {
            noDataScreenView.isHidden = noteInformation == nil ? false : true
            noteCollectionView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    private lazy var noDataScreenView: NoDataScreenView = {
        let view = NoDataScreenView()
        view.setLabel(text: "메모가 없습니다.\n조금만 기다려 볼까요?", range: "조금만 기다려 볼까요?")
        
        return view
    }()
    
    let noticeStackView = NoticeStackView(text: "업로드 된 메모는 매일 자정에 초기화됩니다.")
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    private lazy var applyNumberLabel = ImagePlusLabelView()
    
    private lazy var noteCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identi)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var writeNoteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "WriteNoteImage"), for: .normal)
        button.addAction(UIAction { _ in
            self.writeNoteView.isHidden = false
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var writeNoteView: WriteNoteView = {
        let view = WriteNoteView()
        view.writeNoteViewDelegate = self
        
        return view
    }()
    
    private lazy var noteDateProgressView: NoteDateProgressView = {
        let view = NoteDateProgressView()
        view.writeNoteViewDelegate = self
        
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar(title: "메모팅")
        getNoteTingRemainApplyAPI()
        getNoteInformationAPI()
    }
}

extension NoteViewController {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        view.addSubViews([noticeStackView, applyNumberLabel, noteCollectionView, writeNoteButton, noDataScreenView, writeNoteView,noteDateProgressView])
    }
    
    private func setAutoLayout() {
        noticeStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(27)
            make.left.right.equalToSuperview().inset(25)
        }
        
        applyNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(noticeStackView.snp.bottom).offset(11)
            make.right.equalToSuperview().offset(-25)
        }
        
        noteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(applyNumberLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(27)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        writeNoteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.width.height.equalTo(56)
        }
        
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        writeNoteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noteDateProgressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - API

extension NoteViewController {
    private func getNoteInformationAPI() {
        APIGetManager.shared.getNoteInformation { response in
            self.noteInformation = response
        }
    }
    
    private func getNoteTingRemainApplyAPI() {
        APIGetManager.shared.getNoteTingRemainApply { response in
            self.applyNumberLabel.setImagePlusLabelView(imageName: "PointImage", textFont: Pretendard.medium(size: 12) ?? .systemFont(ofSize: 12), labelText: "일일 신청 남은 횟수: \(response?.result ?? 0)회",lableTextColor: UIColor(named: "PrimaryColor") ?? .red)
        }
    }
    
    private func postNoteRegisterAPI(content: String) {
        APIPostManager.shared.postNoteRegister(content: content) { response in
            guard let response = response else { return print("nil 출력")}
            if response.isSuccess {
                self.showAlert(message: "메모가 등록되었습니다.")
            } else {
                self.showAlert(message: response.message)
            }
            self.writeNoteView.isHidden = true
        }
    }
    
    private func postApplyNote(noteID: Int) {
        APIPostManager.shared.postApplyNote(noteID: noteID) { response in
            guard let response = response else { return print(#function,"Rsponse nil")}
            if response.isSuccess {
                let chatRoomVC = ChatRoomVC()
                chatRoomVC.isPushNotification = true
                chatRoomVC.chatRoomID = response.result.chatId
                self.pushViewContoller(viewController: chatRoomVC)
            } else {
                self.showMessage(message: response.message)
            }
        }
    }
}

// MARK: - UICollectionView

extension NoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteInformation?.result.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identi, for: indexPath) as? NoteCollectionViewCell else { return UICollectionViewCell() }
        cell.setCell(content: noteInformation?.result[indexPath.item].content)
        
        return cell
    }
}

extension NoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        return CGSize(width: width, height: width)
    }
    
    // 가로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    // 세로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        25
    }
}

// MARK: - Delegate

extension NoteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noteDateProgressView.isHidden = false
        self.selectedNoteID = noteInformation?.result[indexPath.item].id
    }
}

extension NoteViewController: WriteNoteViewDelegate {
    func tapRegisterButton(contentTextViewText: String) {
        postNoteRegisterAPI(content: contentTextViewText)
    }
    
    func writeNoteViewtapCancelbutton() {
        writeNoteView.isHidden = true
    }
}

extension NoteViewController: NoteDateProgressViewDelegate {
    func tapProgressButton() {
        noteDateProgressView.isHidden = true
        
        postApplyNote(noteID: self.selectedNoteID ?? 0)
    }
    
    func noteDateProgressViewTapCancelbutton() {
        noteDateProgressView.isHidden = true
    }
}
