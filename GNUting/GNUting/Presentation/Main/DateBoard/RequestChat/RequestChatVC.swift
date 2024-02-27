//
//  RequestChatVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit
// MARK: - 채팅신청하기 화면
class RequestChatVC: UIViewController {
    let sampleData = ["짱짱맨(asd123) 컴퓨터과학과 | 21살 | 20학번|안녕하세요...이쁜이 구해요","짱짱맨(asd123) 컴퓨터과학과 | 21살 | 20학번|안녕하세요...이쁜이 구해요","짱짱맨(asd123) 컴퓨터과학과 | 21살 | 20학번|안녕하세요...이쁜이 구해요"]
    
    private lazy var dismissButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "DissmissImg"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateMemeberAddLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        label.text = "과팅 멤버 추가하기"
        return label
    }()
    
    private lazy var memberTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.register(MemBerAddTableViewCell.self, forCellReuseIdentifier: MemBerAddTableViewCell.identi)
        tableView.register(MemberTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemberTableViewHeader.identi)
        return tableView
    }()
    
    private lazy var chatRequestCompletedButton : PrimaryColorButton = {
       let button = PrimaryColorButton()
        button.setText("채팅 신청완료")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        setTableView()
    }

}
extension RequestChatVC{
    private func setTableView(){
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    private func addSubViews() {
        view.addSubViews([dismissButton,dateMemeberAddLabel,memberTableView,chatRequestCompletedButton])
    }
    private func setAutoLayout(){
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        
        dateMemeberAddLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.centerX.equalToSuperview()
        }
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(dateMemeberAddLabel.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview()
        }
        
        chatRequestCompletedButton.snp.makeConstraints { make in
            make.top.equalTo(memberTableView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
}
extension RequestChatVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sampleData.count == 0{
            return 1
        }else {
            return sampleData.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row < sampleData.count{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            cell.setContentLabel(model: sampleData[indexPath.row])
            return cell
        }else{
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: MemBerAddTableViewCell.identi, for: indexPath) as? MemBerAddTableViewCell else { return UITableViewCell()}
            return addCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberTableViewHeader.identi) as? MemberTableViewHeader else {return UIView()}
        headerView.setMemberLabelCount(memberCount: sampleData.count)
        return headerView
    }

}
