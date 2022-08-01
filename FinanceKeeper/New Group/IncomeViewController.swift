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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.incomeTableView.register(UINib(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableViewCell")
        self.incomeTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        
        
        
    }
    
    
    //MARK: - setupTableView
    func setupTableView() {
        incomeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        
        view.addSubview(incomeTableView)
        incomeTableView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().offset(0)
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
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableViewCell", for: indexPath) as! IncomeTableViewCell
            let myIncomes = realm.objects(Income.self)
            let currentIncome = myIncomes[indexPath.row]
            cell.moneyLabelOutlet.text =  "\(currentIncome.name) Р"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            cell.dataLabelOutlet.text = formatter.string(from: currentIncome.date as Date)
            return cell
            
        } else {
            // Header cell
            
            let myIncomes = realm.objects(Income.self)
            let incomesName = myIncomes
            var total: Int = 0
            for income in incomesName {
                print(income.name)
                total += Int(income.name) ?? 0
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            cell.totalBalanceOutlet.text = "\(total) Р"
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 60
        }
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
        }
    }
    
}

extension IncomeViewController: updateTableViewDelegate {
    func reloadTableView() {
        incomeTableView.reloadData()
    }
}
