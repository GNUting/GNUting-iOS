//
//  NotificationVC.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

import UIKit

class NotificationVC: BaseViewController {
    var notificationList : [NotificationModelResult] = [] {
        didSet{
            if notificationList.count == 0 {
                noDataScreenView.isHidden = false
                
            } else {
                noDataScreenView.isHidden = true
                
            }
            notificationTableView.reloadData()
        }
    }
    private lazy var noDataScreenView: NoDataScreenView = {
       let view = NoDataScreenView()
        
        view.setLabel(text: "도착한 알림이 없습니다.\n조금만 기다려 볼까요?", range: "조금만 기다려 볼까요?")
        return view
    }()
    private lazy var  notificationTableView : UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.dataSource = self
        
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identi)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        
        getNotificationData()
        setNavigationBarPresentType(title: "알림")
    }
    
    
}
extension NotificationVC{
    private func setAddSubViews() {
        view.addSubViews([notificationTableView,noDataScreenView])
    }
    private func setAutoLayout(){
        notificationTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
  
}

extension NotificationVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identi, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.setCell(model: notificationList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            APIDeleteManager.shared.deleteNotification(notificationID: notificationList[indexPath.row].id) { response in
                if response.isSuccess {
                    DispatchQueue.main.async {
                        self.notificationList.remove(at: indexPath.row)
                    }
                } else {
                    let alertController = UIAlertController(title: "오류 발생", message: "다시 시도해주세요", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }
}
extension NotificationVC{
    private func getNotificationData(){
        APIGetManager.shared.getNotificationData { notificationData in
            guard let notificationDataList = notificationData else { return }
            if notificationDataList.isSuccess {
                self.notificationList = notificationDataList.result
            } else {
                self.showAlert(message: notificationData?.message ?? "다시 시도해보세요")
            }
        }
    }
}
