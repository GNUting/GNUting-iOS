//
//  UserWriteTextVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

// MARK: - 내가 작성한글

class UserWriteTextVC: BaseViewController {
    var myPostList : [MyPostResult] = [] {
        didSet{
            if myPostList.count == 0 {
                noDataScreenView.isHidden = false
                writeTextButton.isHidden = false
            } else {
                noDataScreenView.isHidden = true
                writeTextButton.isHidden = true
            }
            dateBoardTableView.reloadData()
        }
    }
    private lazy var noDataScreenView: NoDataScreenView = {
       let view = NoDataScreenView()
        
        view.setLabel(text: "내가 쓴 게시글이없습니다.\n아래 버튼을 눌러 과팅 게시글을 써 보세요!", range: "아래 버튼을 눌러 과팅 게시글을 써 보세요!")
        return view
    }()
    private lazy var writeTextButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "WritePostImage"), for: .normal)
        button.addTarget(self, action: #selector(tapWriteTextButton), for: .touchUpInside)
        return button
    }()
    private lazy var dateBoardTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(BoardListTableViewCell.self, forCellReuseIdentifier: BoardListTableViewCell.identi)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        addSubViews()
        setAutoLayout()
        setNavigationBar(title: "내가 쓴 게시글")
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
        view.addSubViews([dateBoardTableView,noDataScreenView,writeTextButton])
    }
    private func setAutoLayout(){
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        writeTextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.right.equalToSuperview().offset(-25)
            make.height.width.equalTo(60)
        }
    }
}
extension UserWriteTextVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
        vc.boardID = myPostList[indexPath.row].id
        vc.setPushMypostVersion()
        tableView.deselectRow(at: indexPath, animated: true)
        if myPostList[indexPath.row].status == "OPEN" {
            pushViewContoller(viewController: vc)
        }
        
    }
}
extension UserWriteTextVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardListTableViewCell.identi, for: indexPath) as? BoardListTableViewCell else {return BoardListTableViewCell()}
        cell.setCell(model: myPostList[indexPath.row])
        
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
//MARK: - Delegate
extension UserWriteTextVC: WritePostButtonDelegate {
    func tapButton() {
        pushViewContoller(viewController: WriteDateBoardVC())
    }
}
