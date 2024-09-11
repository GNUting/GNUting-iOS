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
    private var noteInformation: NoteModel? {
        didSet {
            noteCollectionView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    let noticeStackView = NoticeStackView(text: "업로드 된 메모는 매일 자정에 초기화됩니다.")
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    private lazy var applyNumberLabel: ImagePlusLabelView = {
        let labelView = ImagePlusLabelView()
        labelView.setImagePlusLabelView(imageName: "PointImage", textFont: Pretendard.medium(size: 12) ?? .systemFont(ofSize: 12), labelText: "일일 신청 남은 횟수: 3회",lableTextColor: UIColor(named: "PrimaryColor") ?? .red)
        
        return labelView
    }()
    
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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar(title: "메모팅")
        getNoteInformationAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension NoteViewController {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        
        view.addSubViews([noticeStackView, applyNumberLabel, noteCollectionView, writeNoteButton, writeNoteView])
    }
    private func setAutoLayout(){
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
        
        writeNoteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - API

extension NoteViewController {
    private func getNoteInformationAPI() {
        APIGetManager.shared.getNoteInformation { noteData in
            self.noteInformation = noteData
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

extension NoteViewController: WriteNoteViewDelegate {
    func tapCancelbutton() {
        writeNoteView.isHidden = true
    }
}
