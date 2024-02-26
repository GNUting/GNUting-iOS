//
//  TermsVC.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

import UIKit
import SnapKit
class TermsVC: UIViewController {
    let textArr = ["만 18세이상입니다. ","(필수)서비스 이용약관","(필수) 개인 정보 처리 방침","(선택) 위치정보 제공","(선택) 마케팅 수신 동의)"]
    var allCheckSelected : Bool = false
    private lazy var allCheckTermsView : AllCheckTermsView = {
        let view = AllCheckTermsView()
        view.tapAllCheckButtonClosure = { [unowned self] selected in
            self.allCheckSelected = selected
            termsTableView.reloadData()
        }
        return view
    }()
    private lazy var termsTableView : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.identi)
        return tableView
    }()
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음으로")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  .white
        addSubViews()
        setAutoLayout()
        setNavigationBar()
        tableViewConfigure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
extension TermsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.identi, for: indexPath) as? TermsTableViewCell else {return UITableViewCell()}
        cell.tapCheckButtonClosure = { [unowned self] selected in
            if !selected{
                allCheckTermsView.checkButton.isSelected = false
            }
        }
        cell.setTextLabel(textArr[indexPath.row])
        cell.setAllCheckButton(AllCheckButtonSelected: self.allCheckSelected)
        return cell
    }
    
}
extension TermsVC{
    private func tableViewConfigure(){
        termsTableView.delegate = self
        termsTableView.dataSource = self
    }
    private func addSubViews(){
        self.view.addSubViews([allCheckTermsView,termsTableView,nextButton])
    }
    private func setAutoLayout(){
        allCheckTermsView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        termsTableView.snp.makeConstraints { make in
            make.top.equalTo(allCheckTermsView.snp.bottom)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
        }
    }
    private func setNavigationBar(){
        let popButton = UIBarButtonItem(image: UIImage(named: "PopImg"), style: .plain, target: self, action: #selector(popButtonTap))
        popButton.tintColor = UIColor(named: "Gray")
        self.navigationItem.leftBarButtonItem = popButton
        self.navigationItem.title = "서비스 이용 동의"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
    }
}
//MARK: - Action
extension TermsVC{
    @objc private func tapNextButton(){
        let vc = SignUpFirstProcessVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
