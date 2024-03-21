//
//  UserWriteTextVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

// MARK: - 내가 작성한글

class UserWriteTextVC: UIViewController {
    var myPostList : [MyPostResult] = [] {
        didSet{
            dateBoardTableView.reloadData()
        }
    }
    
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
        tabBarController?.tabBar.isHidden = true
        addSubViews()
        setAutoLayout()
        setNavigationBar(title: "작성한 글 목록")
        setTableView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyPostList()
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
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
extension UserWriteTextVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
        vc.boardID = myPostList[indexPath.row].id
        vc.setPushMypostVersion()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UserWriteTextVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateBoardListTableViewCell.identi, for: indexPath) as? DateBoardListTableViewCell else {return DateBoardListTableViewCell()}
        cell.myPostSetCell(model: myPostList[indexPath.row])
        return cell
    }
   
    
}
extension UserWriteTextVC {
    private func getMyPostList(){
        APIGetManager.shared.getMyPost { postListInfo,response  in
            if response?.isSuccess == false {
                self.showAlert(message: response?.message ?? "재접속 또는 로그아웃후 다시 시도하세요.")
            }
            guard let result = postListInfo?.result else { return }
            self.myPostList = result
        }
    }
}
