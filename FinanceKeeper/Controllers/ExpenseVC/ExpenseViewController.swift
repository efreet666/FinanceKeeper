//
//  ExpenseViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 01.08.2022.
//

import UIKit
import RealmSwift

protocol updateExpanceTableViewDelegate: ExpenseViewController {
    func reloadTableView()
}

class ExpenseViewController: UIViewController {

    let realm = try! Realm()
    
    let categoryTableView = UITableView()
    let addNewCategoryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        
        addNewCategoryButton.setTitle("Добавить категорию расходов", for: .normal)
        addNewCategoryButton.backgroundColor = .blue
        addNewCategoryButton.layer.cornerRadius = 15
        addNewCategoryButton.addTarget(self, action: #selector(openAddSubview), for: .touchUpInside)
        view.addSubview(addNewCategoryButton)
        addNewCategoryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(150)
            make.height.equalTo(48)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        
    }
    
    @objc func openAddSubview() {
        let modalViewController = addExpenceViewController()
        modalViewController.modalPresentationStyle = .popover
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modalViewController.delegate = self
        present(modalViewController, animated: true, completion: nil)
    }
}

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myIncomes = realm.objects(NewIncome.self)
        print(myIncomes)
        return (myIncomes.count) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // Header cell
            
            let myIncomes = realm.objects(NewIncome.self)
            let incomesName = myIncomes
            var total: Int = 0
            for income in incomesName {
                print(income.amount)
                total += Int(income.amount) ?? 0
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            cell.totalBalanceOutlet.text = "\(total) Р"
            return cell
        

    }
    
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    
            return .delete
       
    }
    
    // MARK: - Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let myIncomes = realm.objects(NewIncome.self)
            
            let currentIncome = myIncomes[indexPath.row - 1]
            try! realm.write {
                realm.delete(currentIncome)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
}

extension ExpenseViewController: updateExpanceTableViewDelegate {
    func reloadTableView() {
        categoryTableView.reloadData()
    }
}
