//
//  TermsVC.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

import UIKit
import SnapKit

// MARK: - 이용약관 ViewController

class TermsVC: UIViewController{
    
    // MARK: - Properties
    
    private var allCheckSelected : Bool = false
    private var defaultSelectedState : [Bool] = [false,false,false]
    
    // MARK: - SubViews
    
    private lazy var allCheckTermsView: AllCheckTermsView = {
        let view = AllCheckTermsView()
        view.allCheckTermsViewDelegate = self
        
        return view
    }()
    
    private lazy var termsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.identi)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var nextButton: PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("다음")
        button.isEnabled = false
        button.addAction(UIAction { _ in
            self.pushViewContoller(viewController: SignUpFirstProcessVC())
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
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

// MARK: - Layout Helpers

extension TermsVC {
    private func addSubViews() {
        self.view.addSubViews([allCheckTermsView, termsTableView, nextButton])
    }
    
    private func setAutoLayout() {
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

// MARK: - Private Method

extension TermsVC {
    private func setNextButton() {
        if defaultSelectedState.allSatisfy({ $0 }) {
            allCheckTermsView.checkButtonSelected(isSelected: true)
            nextButton.backgroundColor = UIColor(named: "PrimaryColor")
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = UIColor(named: "DisableColor")
            nextButton.isEnabled = false
        }
    }
    
    private func allCheckButton(selected : Bool) {
        defaultSelectedState = Array(repeating: selected, count: defaultSelectedState.count)
        nextButton.isEnabled = selected
        nextButton.backgroundColor = selected ? UIColor(named: "PrimaryColor") : UIColor(named: "DisableColor")
    }
}

// MARK: - UITableView

extension TermsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.identi, for: indexPath) as? TermsTableViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.termsTableViewCellDelegate = self
        cell.setTextLabel(type: Terms.termsArray[indexPath.row].type, description: Terms.termsArray[indexPath.row].description)
        cell.setIndexPath(indexPath: indexPath)
        cell.setAllCheckButton(AllCheckButtonSelected: self.allCheckSelected)
        
        return cell
    }
}

// MARK: - Delegate

extension TermsVC: TermsTableViewCellDelegate { // 체크 버튼 클릭
    func checkButtonAction(isSelected: Bool, indexPath: IndexPath) {
        if !isSelected {
            allCheckTermsView.checkButtonSelected(isSelected: isSelected)
        }
        
        defaultSelectedState[indexPath.row] = isSelected
        setNextButton()
    }
    
    func pushButtonAction(indexPath: IndexPath) { // 자세히보기 버튼(">") 클릭
        switch indexPath.row {
        case 1:
            TermsURL.openURLSafari(type: .personalInformation)
        case 2:
            TermsURL.openURLSafari(type: .serviceUse)
        default:
            break
        }
    }
}

extension TermsVC: AllCheckTermsViewDelegate { // 전체 동의 버튼 클릭
    func tapButtonAction(isSelected: Bool) {
        self.allCheckSelected = isSelected
        allCheckButton(selected: isSelected)
        termsTableView.reloadData()
    }
}
