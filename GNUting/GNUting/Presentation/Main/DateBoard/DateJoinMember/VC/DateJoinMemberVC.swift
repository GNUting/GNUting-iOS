//
//  DateJoinMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//
import UIKit

class DateJoinMemberVC: UIViewController {
    private lazy var tempLabel = UILabel()
    private lazy var dismissButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "DissmissImg"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var memberTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(DateJoinMemberTableViewCell.self, forCellReuseIdentifier: DateJoinMemberTableViewCell.identi)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        setTableView()
    }
}

extension DateJoinMemberVC {
    private func setTableView() {
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    
    private func setAddSubViews() {
        view.addSubViews([dismissButton,memberTableView])
    }
    
    private func setAutoLayout(){
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview()
        }
    }
}

extension DateJoinMemberVC : UITableViewDelegate {
    
}

extension DateJoinMemberVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateJoinMemberTableViewCell.identi, for: indexPath) as? DateJoinMemberTableViewCell else { return UITableViewCell() }
        return cell
    }

}
