//
//  TermsVC.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

import UIKit
import SnapKit
class TermsVC: UIViewController{
    let textArr = ["(필수) 경상국립대학교 재학중입니다.","(필수) 개인 정보 처리 방침","(필수) 서비스 이용약관 동의"]
    var allCheckSelected : Bool = false

    var selectedState : [Bool] = [false,false,false]
    private lazy var allCheckTermsView : AllCheckTermsView = {
        let view = AllCheckTermsView()
        view.tapAllCheckButtonClosure = { [unowned self] selected in
            allCheckSelected = selected
            self.allCheckButton(selected: selected)
            termsTableView.reloadData()
        }
        return view
    }()
    private lazy var termsTableView : UITableView = {
       let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.identi)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private lazy var nextButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  .white
        addSubViews()
        setAutoLayout()
        setNavigationBar(title: "서비스 이용 약관 동의")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
extension TermsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.identi, for: indexPath) as? TermsTableViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        
        cell.pushButtonDelegate = self
        cell.tapCheckButtonClosure = { [unowned self] selected in
            if !selected{
                allCheckTermsView.checkButtonSelected(isSelected: selected)
            }
            selectedState[indexPath.row] = selected
            if selectedState.filter({$0 == true}).count == 3 {
                allCheckTermsView.checkButtonSelected(isSelected: true)
            }
            setNextButton()
        }
        if indexPath.row == 0 {
            cell.hiddenPushButton()
        }
        cell.setTextLabel(textArr[indexPath.row],indexPath: indexPath)
        cell.setAllCheckButton(AllCheckButtonSelected: self.allCheckSelected)
        return cell
    }
    
}

extension TermsVC{
    private func addSubViews(){
        self.view.addSubViews([allCheckTermsView,termsTableView,nextButton])
    }
    private func setAutoLayout(){
        allCheckTermsView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Spacing.upperTop)
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
}

// MARK: - Method
extension TermsVC{
    private func setNextButton(){
        if selectedState[0] == true && selectedState[1] == true && selectedState[2] == true{
            nextButton.backgroundColor = UIColor(named: "PrimaryColor")
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = UIColor(named: "DisableColor")
            nextButton.isEnabled = false
        }
    }
    private func allCheckButton(selected : Bool) {
        if selected {
            selectedState = [true,true,true]
            nextButton.backgroundColor = UIColor(named: "PrimaryColor")
            nextButton.isEnabled = true
        } else {
            selectedState = [false,false,false]
            nextButton.backgroundColor = UIColor(named: "DisableColor")
            nextButton.isEnabled = false
        }
    }
}
//MARK : - Action
extension TermsVC{
    @objc private func tapNextButton(){
        pushViewContoller(viewController: SignUpFirstProcessVC())
    }
    
}
extension TermsVC: PushButtonDelegate{
    func buttonAction(indexPath: IndexPath) {
        var urlString = ""
        if indexPath.row == 1 {
            urlString = "https://gnuting.github.io/GNUting-PrivacyPolicy/privacy_policy"
        } else {
            urlString = "https://equal-kiwi-602.notion.site/9021bea8cf1841fc8a83d26a06c8e72c"
        }
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
        
    }
    
    
}
