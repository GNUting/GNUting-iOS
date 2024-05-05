//
//  RequestStatusVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit

class RequestStateVC: BaseViewController {
    var selectedSegmentIndex: Int = 0
    var dateStatusAllInfos : [ApplicationStatusResult] = []
    var dateStatusList : [DateStateModel] = []{
        didSet{
            if dateStatusList.count == 0 {
                noDataScreenView.isHidden = false
                
            } else {
                noDataScreenView.isHidden = true
                
            }
            requsetListTableView.reloadData()
        }
    }
    
    private lazy var noDataScreenView: NoDataScreenView = {
       let view = NoDataScreenView()
        
        view.setLabel(text: "신청현황이 비어있습니다.\n과팅 게시판을 이용하거나 게시글을 써보세요!", range: "과팅 게시판을 이용하거나 게시글을 써보세요!")
        return view
    }()
    private lazy var segmentedControl : UnderLineSegmentedControl = {
        let control = UnderLineSegmentedControl(items: ["신청목록","신청 받은 목록"])
        control.addTarget(self, action: #selector(didchangeValue(segment :)), for: .valueChanged)
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor")!,
                .font: UIFont(name: Pretendard.Medium.rawValue, size: 13)!],
            for: .selected
        )
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor(hexCode: "6C7072"),
                .font: UIFont(name: Pretendard.Medium.rawValue, size: 13)!],
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
        
        addSubViews()
        setAutoLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        if selectedSegmentIndex == 0{
            getRequestStatus()
        } else {
            getReceivedState()
        }
        
    }
}
extension RequestStateVC{
    private func addSubViews() {
        self.view.addSubViews([segmentedControl,requsetListTableView,noDataScreenView])
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
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}
extension RequestStateVC {
    @objc private func didchangeValue(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            selectedSegmentIndex = 0
            getRequestStatus()
        } else {
            selectedSegmentIndex = 1
            getReceivedState()
        }
        
    }
}

extension RequestStateVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestStatusDetailVC()
        vc.dedatilData = dateStatusAllInfos[indexPath.row]
        if selectedSegmentIndex == 0{
            vc.requestStatus = true
        }else {
            vc.requestStatus = false
        }
        pushViewContoller(viewController: vc)
    }
}

extension RequestStateVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateStatusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequsetListTableViewCell.identi, for: indexPath) as? RequsetListTableViewCell else { return UITableViewCell() }
        cell.setCell(model: dateStatusList[indexPath.row])
        return cell
    }
    
    
}
extension RequestStateVC {
    private func getRequestStatus() {
        APIGetManager.shared.getRequestChatState { requestStatusData, response in
            self.errorHandling(response: response)
            guard let results = requestStatusData?.result else { return }
            self.dateStatusAllInfos = results
            self.dateStatusList = []
            for result in results {
                let participantUserDepartment = result.participantUserDepartment
                let participantUserCount = result.participantUserCount
                var applyStatus : RequestState = .waiting
            
                switch result.applyStatus{
                case "승인":
                    applyStatus = .Success
                case "거절":
                    applyStatus = .refuse
                default:
                    applyStatus = .waiting
                }
                self.dateStatusList.append(DateStateModel(major: participantUserDepartment, memeberCount: participantUserCount, applyStatus: applyStatus))
            }
            
            
        }
    }
    private func getReceivedState() {
        APIGetManager.shared.getReceivedChatState{ requestStatusData, response in
            self.errorHandling(response: response)
            guard let results = requestStatusData?.result else { return }
            self.dateStatusAllInfos = results
            
            self.dateStatusList = []
            guard let results = requestStatusData?.result else { return }
            for result in results {
                let applyUserDepartment = result.applyUserDepartment
                let applyUserCount = result.applyUserCount
                var applyStatus : RequestState = .waiting
                switch result.applyStatus{
                case "승인":
                    applyStatus = .Success
                case "거절":
                    applyStatus = .refuse
                default:
                    applyStatus = .waiting
                }

                self.dateStatusList.append(DateStateModel(major: applyUserDepartment, memeberCount: applyUserCount, applyStatus: applyStatus))
            }
            
            
        }
    }
}
