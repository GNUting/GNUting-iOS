//
//  NotificationVC.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

import UIKit

class NotificationVC: UIViewController {
    var notificationList : [NotificationModelResult] = [] {
        didSet{
            notificationTableView.reloadData()
        }
    }
    private lazy var  notificationTableView : UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.dataSource = self
        
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identi)
        tableView.separatorStyle = .none
        
        return tableView
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        
        getNotificationData()
        setNavigationBarPresentType(title: "알림")
    }
    
    
}
extension NotificationVC{
    private func setAddSubViews() {
        view.addSubview(notificationTableView)
    }
    private func setAutoLayout(){
        notificationTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalToSuperview()
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
                    
                    let alertController = UIAlertController(title: "알림 삭제", message: "해당 알림이 리스트에서 삭제되었습니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
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
