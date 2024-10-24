//
//  NotificationVC.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

// MARK: - 알림 List ViewController

import UIKit

final class NotificationVC: BaseViewController {
    
    // MARK: - Properties
    
    private var notificationList: [NotificationModelResult] = [] {
        didSet{
            noDataScreenView.isHidden = notificationList.count == 0 ? false : true
            notificationTableView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    private lazy var noDataScreenView: NoDataScreenView = {
        let view = NoDataScreenView()
        view.setLabel(text: "도착한 알림이 없습니다.\n조금만 기다려 볼까요?", range: "조금만 기다려 볼까요?")
        
        return view
    }()
    
    private lazy var  notificationTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identi)
        tableView.allowsSelection = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        getNotificationDataAPI()
        setNavigationBarPresentType(title: "알림")
    }
}

// MARK: - Layout Helpers

extension NotificationVC {
    private func setAddSubViews() {
        view.addSubViews([notificationTableView, noDataScreenView])
    }
    
    private func setAutoLayout() {
        notificationTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

// MARK: - API

extension NotificationVC {
    private func getNotificationDataAPI() {
        APIGetManager.shared.getNotificationData { notificationData in
            guard let notificationDataList = notificationData else { return }
        
            if notificationDataList.isSuccess {
                self.notificationList = notificationDataList.result
            } else {
                self.showAlert(message: notificationData?.message ?? "다시 시도해보세요")
            }
        }
    }
    
    private func deleteNotificationAPI(notificationID: Int, indexPath: IndexPath) {
        APIDeleteManager.shared.deleteNotification(notificationID: notificationID) { response in
            if response.isSuccess {
                DispatchQueue.main.async {
                    self.notificationList.remove(at: indexPath.row)
                }
            } else {
                self.showAlert(title: "오류 발생", message: "다시 시도해주세요.")
            }
        }
    }
}

// MARK: - UITableView

extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identi, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.setCell(model: notificationList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNotificationAPI(notificationID: notificationList[indexPath.row].id, indexPath: indexPath)
        }
    }
}

// MARK: - Delegate

extension NotificationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = notificationList[indexPath.row].location
        let locationID = notificationList[indexPath.row].locationId
        let vc = TabBarController()
        
        vc.selectedIndex = location == "chat" ? 2 : 1
        
        switch location {
        case "apply", "cancel", "refuse": // 신청 관련
            let requestVC = vc.secondVC.topViewController as? RequestStateVC
            
            requestVC?.selectedSegmentIndex = location == "refuse" ? 0 : 1
            if location == "apply" {
                requestVC?.getApplicationReceivedData(ApplicatoinID: String(locationID ?? 0), requestStatus: false)
            } else if location == "refuse" {
                requestVC?.getApplicationReceivedData(ApplicatoinID: String(locationID ?? 0), requestStatus: true)
            }
            view.window?.rootViewController = vc
        case "chat":
            let chatRoomVC = ChatRoomVC()
            chatRoomVC.isPushNotification = true
            chatRoomVC.chatRoomID = locationID ?? 0
            self.pushViewContoller(viewController: chatRoomVC)
            

        default:
            break
        }
        
    }
}
