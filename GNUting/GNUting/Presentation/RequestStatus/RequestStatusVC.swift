//
//  RequestStatusVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit

class RequestStatusVC: UIViewController {
    let sampleDate = [RequestState.Success,RequestState.Failure,RequestState.waiting]
    private lazy var segmentedControl : UnderLineSegmentedControl = {
        let control = UnderLineSegmentedControl(items: ["신청목록","신청 받은 목록"])
        control.addTarget(self, action: #selector(didchangeValue(segment :)), for: .valueChanged)
        control.setTitleTextAttributes(
            [
              NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor")!,
              .font: UIFont(name: Pretendard.Medium.rawValue, size: 13)!            ],
            for: .selected
          )
        control.setTitleTextAttributes(
            [
              NSAttributedString.Key.foregroundColor: UIColor(hexCode: "6C7072"),
              .font: UIFont(name: Pretendard.Medium.rawValue, size: 13)!            ],
            for: .normal
          )
        control.selectedSegmentIndex = 0
        return control
    }()
    private lazy var requsetListTableView : UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RequsetListTableViewCell.self, forCellReuseIdentifier: RequsetListTableViewCell.identi)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
    }
}
extension RequestStatusVC{
    private func addSubViews() {
        self.view.addSubViews([segmentedControl,requsetListTableView])
    }
    private func setAutoLayout(){
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        requsetListTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}
extension RequestStatusVC {
    @objc private func didchangeValue(segment: UISegmentedControl) {
        print(segment.selectedSegmentIndex)
    }
}
extension RequestStatusVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequsetListTableViewCell.identi, for: indexPath) as? RequsetListTableViewCell else { return UITableViewCell() }
        cell.setRequestStateLabel(state: sampleDate[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestStatusDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
