//
//  RequestStatusDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class RequestStatusDetailVC: UIViewController {
    private lazy var requestStateLabel : BasePaddingLabel = {
       let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 16)
        label.textColor = .white
        label.text = "대기중"
        label.backgroundColor = UIColor(named: "PrimaryColor")
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    private lazy var dateMemeberTableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(DateMemberTableViewCell.self, forCellReuseIdentifier: DateMemberTableViewCell.identi)
        tableView.register(DateMemberHeader.self, forHeaderFooterViewReuseIdentifier: DateMemberHeader.identi)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
    }

}
extension RequestStatusDetailVC{
    private func setAddSubViews() {
        view.addSubViews([requestStateLabel,dateMemeberTableView])
    }
    private func setAutoLayout(){
        requestStateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.right.equalToSuperview()
        }
        dateMemeberTableView.snp.makeConstraints { make in
            make.top.equalTo(requestStateLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
extension RequestStatusDetailVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateMemberTableViewCell.identi, for: indexPath) as? DateMemberTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateMemberHeader.identi) as? DateMemberHeader else { return UIView()}
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
