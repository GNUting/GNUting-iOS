//
//  UserWriteTextVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class UserWriteTextVC: UIViewController {
    let sampeleDetailDateBoardData : [DetailDateBoardModel] = [DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "22학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "23학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "22학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "23학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "21학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "24학번")]
    
    private lazy var dateBoardTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(DateBoardListTableViewCell.self, forCellReuseIdentifier: DateBoardListTableViewCell.identi)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        addSubViews()
        setAutoLayout()
        setNavigationBar(title: "작성한 글 목록")
        setTableView()
    }
    
}
extension UserWriteTextVC{
    private func setTableView(){
        dateBoardTableView.delegate = self
        dateBoardTableView.dataSource = self
    }
    private func addSubViews() {
        view.addSubViews([dateBoardTableView])
    }
    private func setAutoLayout(){
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
extension UserWriteTextVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampeleDetailDateBoardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateBoardListTableViewCell.identi, for: indexPath) as? DateBoardListTableViewCell else {return DateBoardListTableViewCell()}
//        cell.setCell(model: sampeleDetailDateBoardData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
        vc.setTitleLabel(title: sampeleDetailDateBoardData[indexPath.row].title)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
