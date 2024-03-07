//
//  WriteDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class WriteUpdateDateBoardVC: UIViewController {
    var titleState = "글쓰기"
    let textViewPlaceHolder = "내용을 입력해주세요."
    let sampleData = ["짱짱맨(asd123) 컴퓨터과학과 | 21살 | 20학번|안녕하세요...이쁜이 구해요","짱짱맨(asd123) 컴퓨터과학과 | 21살 | 20학번|안녕하세요...이쁜이 구해요","짱짱맨(asd123) 컴퓨터과학과 | 21살 | 20학번|안녕하세요...이쁜이 구해요"]
    private lazy var titleContentView : WrtieUpdateTitleContentView = {
        let customView = WrtieUpdateTitleContentView()
        customView.contentTextView.delegate = self
        customView.contentTextView.text = textViewPlaceHolder
        
        return customView
    }()
    private lazy var memberTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.register(MemBerAddTableViewCell.self, forCellReuseIdentifier: MemBerAddTableViewCell.identi)
        tableView.register(MemberTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemberTableViewHeader.identi)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        setNavigationBar()
        setTableView()
    }
    

}
extension WriteUpdateDateBoardVC{
    private func setTableView(){
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    private func setNavigationBar(){
        setNavigationBar(title: "\(titleState)")
        
        let completedButton = UIButton()
        completedButton.setTitle("완료", for: .normal)
        completedButton.titleLabel?.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        completedButton.setTitleColor(UIColor(named: "SecondaryColor"), for: .normal)
        completedButton.addTarget(self, action: #selector(tapCompletedButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }
    private func addSubViews() {
        view.addSubViews([titleContentView,memberTableView])
    }
    private func setAutoLayout(){
        titleContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
//            make.height.equalTo(self.view.frame.height).dividedBy(3)
        }
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(titleContentView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}
extension WriteUpdateDateBoardVC : UITableViewDelegate,UITableViewDataSource {
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
extension WriteUpdateDateBoardVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == textViewPlaceHolder {
               textView.text = nil
               textView.textColor = .black
               
           }
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
               textView.text = textViewPlaceHolder
               textView.textColor = UIColor(hexCode: "9F9F9F")
           }
       }
}

extension WriteUpdateDateBoardVC{
    @objc private func tapCompletedButton(){
    
    }
}
extension WriteUpdateDateBoardVC {
    public func sendDetailTextData(textTuple : (String,String)) {
        titleContentView.setTitleTextFieldText(text: textTuple.0)
        titleContentView.setContentTextView(text: textTuple.1)
        titleContentView.setContentTextViewTextColor(color: .black)
    }
    
}
