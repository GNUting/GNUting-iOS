//
//  DateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardVC: UIViewController {
    let sampeleDetailDateBoardData : [DetailDateBoardModel] = [DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "22학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "23학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "22학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "23학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "21학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "24학번")]
    private lazy var dateBoardTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(DetailDateBoardTableViewCell.self, forCellReuseIdentifier: DetailDateBoardTableViewCell.identi)
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var writeTextButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("글쓰기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 16)!]))
        config.image = UIImage(named: "Edit")
        config.baseForegroundColor = .black
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 20
        button.addTarget(self, action: #selector(tapWriteTextButton), for: .touchUpInside)
        return button
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
extension DateBoardVC{
    private func setTableView(){
        dateBoardTableView.delegate = self
        dateBoardTableView.dataSource = self
    }
    private func addSubViews() {
        view.addSubViews([dateBoardTableView,writeTextButton])
    }
    private func setAutoLayout(){
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        writeTextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    private func setNavigationBar(){
        let backButton = BackButton()
        backButton.setConfigure(text: "홈")
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.title = "과팅 게시판"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SearchImg"), style: .plain, target: self, action: #selector(tapSearchButton))
        rightBarButtonItem.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}
extension DateBoardVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampeleDetailDateBoardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailDateBoardTableViewCell.identi, for: indexPath) as? DetailDateBoardTableViewCell else {return DetailDateBoardTableViewCell()}
        cell.setCell(model: sampeleDetailDateBoardData[indexPath.row])
        return cell
    }
    
    
}
extension DateBoardVC {
    @objc private func tapSearchButton(){
        let vc = UINavigationController.init(rootViewController: BoardTextSearchVC())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc private func tapWriteTextButton(){
        let vc = WriteDateBoardVC()
        self.present(vc, animated: true)
    }
}

