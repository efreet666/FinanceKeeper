//
//  ViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 22.07.2022.
//

import UIKit
import SnapKit
import RealmSwift

protocol updateTableViewDelegate: IncomeViewController {
    func reloadTableView()
}

class IncomeViewController: UIViewController {

    let realm = try! Realm()
    
    let incomeTableView = UITableView()
    let totalIncomeLabel = UILabel()
    let currentBalanceLabel = UILabel()
    
    @IBAction func addNewIncomeButton(_ sender: Any) {
        segueToAddIncomeVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTotalLabel()
    }
    
    //MARK: - Total label
    func setupTotalLabel() {
        let myIncomes = realm.objects(Income.self)
        let incomesName = myIncomes
        var total: Int = 0
        for income in incomesName {
            print(income.name)
            total += Int(income.name) ?? 0
        }
        
        totalIncomeLabel.text = "\(total) Р"
        totalIncomeLabel.textAlignment = .right
        self.view.addSubview(totalIncomeLabel)
        totalIncomeLabel.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview().inset(80)
            make.height.equalTo(60)
        }
        
        currentBalanceLabel.text = "Текущий баланс"
        currentBalanceLabel.textAlignment = .left
        self.view.addSubview(currentBalanceLabel)
        currentBalanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(totalIncomeLabel).inset(20)
            make.height.equalTo(60)
        }
    }
    
    //MARK: - setupTableView
    func setupTableView() {
        incomeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        
        view.addSubview(incomeTableView)
        incomeTableView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
    }
    
    func segueToAddIncomeVC() {
        let modalViewController = AddIncomeViewController()
        modalViewController.modalPresentationStyle = .popover
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modalViewController.delegate = self
        present(modalViewController, animated: true, completion: nil)
    }

}

extension IncomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myIncomes = realm.objects(Income.self)
        print(myIncomes)
        return myIncomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let myIncomes = realm.objects(Income.self)
        let currentIncome = myIncomes[indexPath.row]
        cell.textLabel?.text = "\(currentIncome.name) Р"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: - Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let myIncomes = realm.objects(Income.self)
            
            let currentIncome = myIncomes[indexPath.row]
            try! realm.write {
                realm.delete(currentIncome)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            setupTotalLabel()
        }
    }

}

extension IncomeViewController: updateTableViewDelegate {
    func reloadTableView() {
        incomeTableView.reloadData()
        setupTotalLabel()
    }
}
