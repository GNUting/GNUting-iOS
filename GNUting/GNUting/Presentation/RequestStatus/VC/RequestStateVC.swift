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
            requsetListTableView.refreshControl?.endRefreshing()
            requsetListTableView.reloadData()
        }
    }
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "신청 현황"
        label.font = Pretendard.medium(size: 18)
        return label
    }()
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
                .font: Pretendard.medium(size: 13) ?? .systemFont(ofSize: 13)],
            for: .selected
        )
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor(hexCode: "6C7072"),
                .font: Pretendard.medium(size: 13) ?? .systemFont(ofSize: 13)],
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
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadBoardListData), for: .valueChanged)
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
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        setSegmentedControl(selectedIndex: self.selectedSegmentIndex)
    }
}
extension RequestStateVC{
    private func addSubViews() {
        self.view.addSubViews([titleLabel, segmentedControl, requsetListTableView, noDataScreenView])
    }
    private func setAutoLayout(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.left.right.equalToSuperview()
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.upperTop)
            make.centerX.equalToSuperview()
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
    @objc private func reloadBoardListData() {
        setSegmentedControl(selectedIndex: self.selectedSegmentIndex)
    }
}



extension RequestStateVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateStatusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequsetListTableViewCell.identi, for: indexPath) as? RequsetListTableViewCell else { return UITableViewCell() }
        cell.setCell(model: dateStatusList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if dateStatusAllInfos[indexPath.row].applyStatus != "대기중" {
            if editingStyle == .delete{
                if selectedSegmentIndex == 0 {
                    APIPatchManager.shared.deleteApplystate(chatRoomID: dateStatusAllInfos[indexPath.row].id) { response in
                        if response.isSuccess {
                            DispatchQueue.main.async {
                                self.dateStatusAllInfos.remove(at: indexPath.row)
                                self.dateStatusList.remove(at: indexPath.row)
                            }
                            self.showAlert(message: "신청목록이 삭제 되었습니다.")
                        }
                    }
                } else {
                    APIPatchManager.shared.deleteReceivedstate(chatRoomID: dateStatusAllInfos[indexPath.row].id) { response in
                        if response.isSuccess {
                            DispatchQueue.main.async {
                                self.dateStatusAllInfos.remove(at: indexPath.row)
                                self.dateStatusList.remove(at: indexPath.row)
                            }
                            self.showAlert(message: "신청받은 목록이 삭제 되었습니다.")
                        }
                    }
                }
                
            }
        }else {
            self.showAlert(message: "대기중인 상태에서는 삭제가 불가능합니다.")
        }
        
    }
}
extension RequestStateVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestStatusDetailVC()
        vc.dedatilData = dateStatusAllInfos[indexPath.row]
        if selectedSegmentIndex == 0{
            vc.requestStatus = true
        }else {
            vc.requestStatus = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
        pushViewContoller(viewController: vc)
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
//                let participantUserDepartment = result.participantUserDepartment
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
                self.dateStatusList.append(DateStateModel(memeberCount: participantUserCount, applyStatus: applyStatus))
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
//                let applyUserDepartment = result.applyUserDepartment
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

                self.dateStatusList.append(DateStateModel(memeberCount: applyUserCount, applyStatus: applyStatus))
            }
            
            
        }
    }
}
extension RequestStateVC {
    
    func setSegmentedControl(selectedIndex: Int) {
        segmentedControl.selectedSegmentIndex = selectedIndex
        self.selectedSegmentIndex = selectedIndex

        if selectedSegmentIndex == 0{
            getRequestStatus()
        } else {
            getReceivedState()
        }
    }
    func getApplicationReceivedData(ApplicatoinID: String,requestStatus: Bool) {
        let rootVC = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController as? UITabBarController
        let vc = RequestStatusDetailVC()
   
        if requestStatus {
            APIGetManager.shared.getApplicationReceivedData(applcationID: ApplicatoinID) { applicationReceivedData in
                guard let sucess = applicationReceivedData?.isSuccess else { return }
                if sucess {
                    vc.dedatilData = applicationReceivedData?.result
                    vc.requestStatus = true
                    self.pushViewContoller(viewController: vc)
                } else {
                    self.setErrorHandling(errorCode: applicationReceivedData?.code, errorMessage: applicationReceivedData?.message)
                    rootVC?.selectedIndex = 0
                }
            }
        } else {
            APIGetManager.shared.getApplicationReceivedData(applcationID: ApplicatoinID) { applicationReceivedData in
                guard let sucess = applicationReceivedData?.isSuccess else { return }
              
                if sucess {
                    vc.dedatilData = applicationReceivedData?.result
                    vc.requestStatus = false
                    self.pushViewContoller(viewController: vc)
                } else {
                    self.setErrorHandling(errorCode: applicationReceivedData?.code, errorMessage: applicationReceivedData?.message)
                    rootVC?.selectedIndex = 0
                }
                
            }
        }
        
    }
    private func setErrorHandling(errorCode: String?,errorMessage: String?){
        switch errorCode{
        case "APPLY4000":
            showAlert(message: errorMessage ?? "문제가 발생하였습니다. 지속될시 고객센터 문의바랍니다.")
        case "APPLY4004":
            showAlert(message: errorMessage ?? "문제가 발생하였습니다. 지속될시 고객센터 문의바랍니다.")
        case "BOARD5003":
            showAlert(message: errorMessage ?? "문제가 발생하였습니다. 지속될시 고객센터 문의바랍니다.")
        default:
            showAlert(message: errorMessage ?? "문제가 발생하였습니다. 지속될시 고객센터 문의바랍니다.")
        }
    }
    
}
