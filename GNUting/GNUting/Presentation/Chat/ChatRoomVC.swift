//
//  ChatRoomVC.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import UIKit

class ChatRoomVC: UIViewController {
    
    
    var chatRoomID: Int = 0
    var navigationTitle: String = "게시글 제목"
    var subTitleSting: String = "학과|학과"

    private let url = URL(string: "ws://localhost:8080/chat")!
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = subTitleSting
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        label.textColor = UIColor(hexCode: "767676")
        
        return label
    }()
    
    private lazy var borderView = UIView()
    
    private lazy var chatRoomTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
   
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar()
    }
}
extension ChatRoomVC{
    private func setAddSubViews() {
        view.addSubViews([subTitleLabel,borderView,chatRoomTableView])
    }
    private func setAutoLayout(){
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension ChatRoomVC {
    private func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBar(title: self.navigationTitle)
    }
}
extension ChatRoomVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}



