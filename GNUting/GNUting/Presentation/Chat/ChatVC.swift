//
//  ChatVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit

class ChatVC: UIViewController {
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "전체 채팅방"
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 22)
        return label
    }()
    
    private lazy var chatTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identi)
        tableView.separatorStyle = .none
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        setTableViewDataSource()
        setTableViewDelegate()
    }
}
extension ChatVC{
    private func addSubViews() {
        view.addSubViews([titleLabel,chatTableView])
    }
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
        }
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
}
extension ChatVC : UITableViewDataSource {
    private func setTableViewDataSource() {
        chatTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identi, for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    
}
extension ChatVC : UITableViewDelegate {
    private func setTableViewDelegate(){
        chatTableView.delegate = self
    }
}
