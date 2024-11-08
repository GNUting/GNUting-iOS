//
//  RequestStatusVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

// MARK: - 신청 현황 ViewController

import UIKit

final class RequestStateVC: BaseViewController {
    
    // MARK: - Properties
    
    var selectedSegmentIndex: Int = 0
    var dateStatusAllInfos: [ApplicationStatusResult] = []
    var dateStatusList: [DateStateModel] = []{
        didSet{
            noDataScreenView.isHidden = dateStatusList.isEmpty ? false : true
            requsetListTableView.refreshControl?.endRefreshing()
            requsetListTableView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "신청 현황"
        label.font = Pretendard.medium(size: 18)
        
        return label
    }()
    
    private lazy var noDataScreenView: NoDataScreenView = {
       let view = NoDataScreenView()
        
        view.setLabel(text: Strings.RequestState.emptyDataExplain, range: "과팅 게시판을 이용하거나 게시글을 써보세요!")
        return view
    }()
    
    private lazy var segmentedControl: UnderLineSegmentedControl = {
        let control = UnderLineSegmentedControl(items: Strings.RequestState.segmentIndexStrings)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didchangeValue(segment :)), for: .valueChanged)
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor")!,
                .font: Pretendard.medium(size: 13)!],
            for: .selected
        )
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor(hexCode: "6C7072"),
                .font: Pretendard.medium(size: 13)!],
            for: .normal
        )
        
        return control
    }()
    
    private lazy var requsetListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RequestListTableViewCell.self, forCellReuseIdentifier: RequestListTableViewCell.identi)
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadBoardListData), for: .valueChanged)
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    
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

extension RequestStateVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        self.view.addSubViews([titleLabel, segmentedControl, requsetListTableView, noDataScreenView])
    }
    
    private func setAutoLayout() {
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
            make.left.right.equalToSuperview().inset(Spacing.size20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - SetView
    
    private func setSegmentedControl(selectedIndex: Int) {
        segmentedControl.selectedSegmentIndex = selectedIndex
        self.selectedSegmentIndex = selectedIndex
        selectedSegmentIndex == 0 ? getRequestStatusAPI() : getReceivedStateAPI()
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
    
    // MARK: - Internal Method
    
    func fetchAndPushRequestDetail(ApplicatoinID: String,requestStatus: Bool) { // Push 알림 클릭 or 알림 list에서 신청 관련 클릭시
        requestStatus ? getApplicationReceivedDataAPI(ApplicatoinID: ApplicatoinID, requestStatus: true) : getApplicationReceivedDataAPI(ApplicatoinID: ApplicatoinID, requestStatus: false)
    }
    
    // MARK: - Business Logic
    
    private func setApplStatusData(results: [ApplicationStatusResult]) {
        self.dateStatusAllInfos = results
        self.dateStatusList = []
        
        for result in results {
            let applyUserCount = result.applyUserCount
            var applyStatus : RequestState = .waiting
            switch result.applyStatus {
            case "승인":
                applyStatus = .Success
            case "거절":
                applyStatus = .refuse
            default:
                applyStatus = .waiting
            }

            self.dateStatusList.append(DateStateModel(memberCount: applyUserCount, applyStatus: applyStatus))
        }
    }
}

// MARK: - API

extension RequestStateVC {
    private func getRequestStatusAPI() {
        APIGetManager.shared.getRequestChatState { requestStatusData, response in
            self.errorHandling(response: response)
            guard let results = requestStatusData?.result else { return }
            self.setApplStatusData(results: results)
        }
    }
    
    private func getReceivedStateAPI() {
        APIGetManager.shared.getReceivedChatState{ requestStatusData, response in
            self.errorHandling(response: response)
            guard let results = requestStatusData?.result else { return }
            self.setApplStatusData(results: results)
        }
    }
    
    private func getApplicationReceivedDataAPI(ApplicatoinID: String, requestStatus: Bool) {
        let viewController = RequestStatusDetailVC()
        let rootVC = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController as? UITabBarController
        
        APIGetManager.shared.getApplicationReceivedData(applcationID: ApplicatoinID) { applicationReceivedData in
            guard let sucess = applicationReceivedData?.isSuccess else { return }
            if sucess {
                viewController.dedatilData = applicationReceivedData?.result
                viewController.requestStatus = requestStatus
                self.pushViewController(viewController: viewController)
            } else {
                self.setErrorHandling(errorCode: applicationReceivedData?.code, errorMessage: applicationReceivedData?.message)
                rootVC?.selectedIndex = 0
            }
        }
    }
    
    private func deleteApplystateAPI(chatRoomID: Int, indexPathRow: Int) {
        APIPatchManager.shared.deleteApplystate(chatRoomID: chatRoomID) { response in
            if response.isSuccess {
                DispatchQueue.main.async {
                    self.dateStatusAllInfos.remove(at: indexPathRow)
                    self.dateStatusList.remove(at: indexPathRow)
                }
                self.showAlert(message: "신청목록이 삭제 되었습니다.")
            }
        }
    }
    
    private func deleteReceivedstateAPI(chatRoomID: Int, indexPathRow: Int) {
        APIPatchManager.shared.deleteReceivedstate(chatRoomID: chatRoomID) { response in
            if response.isSuccess {
                DispatchQueue.main.async {
                    self.dateStatusAllInfos.remove(at: indexPathRow)
                    self.dateStatusList.remove(at: indexPathRow)
                }
                self.showAlert(message: "신청받은 목록이 삭제 되었습니다.")
            }
        }
    }
}

// MARK: - UITableView DataSource

extension RequestStateVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateStatusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestListTableViewCell.identi, for: indexPath) as? RequestListTableViewCell else { return UITableViewCell() }
        cell.setCell(model: dateStatusList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if dateStatusAllInfos[indexPath.row].applyStatus != "대기중" {
            if editingStyle == .delete{
                selectedSegmentIndex == 0 ? deleteApplystateAPI(chatRoomID: dateStatusAllInfos[indexPath.row].id, indexPathRow: indexPath.row) :
                deleteReceivedstateAPI(chatRoomID: dateStatusAllInfos[indexPath.row].id, indexPathRow: indexPath.row)
            }
        } else {
            self.showAlert(message: "대기중인 상태에서는 삭제가 불가능합니다.")
        }
        
    }
}

// MARK: - Delegate

extension RequestStateVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestStatusDetailVC()
        
        vc.dedatilData = dateStatusAllInfos[indexPath.row]
        vc.requestStatus = selectedSegmentIndex == 0 ? true : false
        tableView.deselectRow(at: indexPath, animated: true)
        pushViewController(viewController: vc)
    }
    
}

// MARK: - Action

extension RequestStateVC {
    @objc private func didchangeValue(segment: UISegmentedControl) {
        selectedSegmentIndex = segment.selectedSegmentIndex
        segment.selectedSegmentIndex == 0 ? getRequestStatusAPI() : getReceivedStateAPI()
    }
    
    @objc private func reloadBoardListData() {
        setSegmentedControl(selectedIndex: self.selectedSegmentIndex)
    }
}
