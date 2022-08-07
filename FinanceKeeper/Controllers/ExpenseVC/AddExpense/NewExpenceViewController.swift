//
//  ViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 06.08.2022.
//

import UIKit
import RealmSwift

protocol updateExpenceTableViewDelegate: NewExpenceViewController {
    func reloadTableView()
    
}

class NewExpenceViewController: UIViewController {

    var currentCategory = ""
    let realm = try! Realm()
    
    let newExpenseTableView = UITableView()
    let addNewCategoryButton = UIButton()
    let openGraphExpenseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newExpenseTableView.dataSource = self
        self.newExpenseTableView.delegate = self
        self.newExpenseTableView.register(UINib(nibName: "NewExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "NewExpenseTableViewCell")
        setupView()
        self.view.backgroundColor = .black
        self.title = currentCategory
    }
    override func viewWillAppear(_ animated: Bool) {
        print(currentCategory)
        self.navigationController?.title = currentCategory
    }
    private func setupView() {
        
        view.addSubview(newExpenseTableView)
        newExpenseTableView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().inset(170)
            make.bottom.equalToSuperview().inset(100)
        }
        
        addNewCategoryButton.setTitle("+", for: .normal)
        addNewCategoryButton.backgroundColor = .blue
        addNewCategoryButton.layer.cornerRadius = 32
        addNewCategoryButton.addTarget(self, action: #selector(openAddSubview), for: .touchUpInside)
        view.addSubview(addNewCategoryButton)
        addNewCategoryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.height.width.equalTo(65)
            make.trailing.equalToSuperview().inset(30)
        }
        
        openGraphExpenseButton.setTitle("График платежей", for: .normal)
        openGraphExpenseButton.backgroundColor = .blue
        openGraphExpenseButton.layer.cornerRadius = 15
        openGraphExpenseButton.addTarget(self, action: #selector(openGraphExpenseVC), for: .touchUpInside)
        view.addSubview(openGraphExpenseButton)
        openGraphExpenseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(48)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        
    }
    
    @objc func openAddSubview() {
        let modalViewController = AddNewExpenseViewController()
        modalViewController.modalPresentationStyle = .popover
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modalViewController.newExpenseCurrentCategory = currentCategory
        modalViewController.delegate = self
        present(modalViewController, animated: true, completion: nil)
    }
    @objc func openGraphExpenseVC() {
        let expenseGraphsVC = ExpenseGraphViewController()
        expenseGraphsVC.currentCategory = currentCategory
        self.navigationController?.pushViewController(expenseGraphsVC, animated: true)
    }
}
extension NewExpenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let predicate = NSPredicate(format: "category BEGINSWITH [c]%@", currentCategory)
        let realm = try! Realm()
        let myResult = realm.objects(NewExpenses.self).filter(predicate)
        return (myResult.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let predicate = NSPredicate(format: "category BEGINSWITH [c]%@", currentCategory)
        let realm = try! Realm()
        let myNewExpense = realm.objects(NewExpenses.self).filter(predicate)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewExpenseTableViewCell", for: indexPath) as! NewExpenseTableViewCell
        
        cell.expenseLabelOutlet.text = myNewExpense[indexPath.row].amount + " Р"
        cell.nameLabelOutlet.text = myNewExpense[indexPath.row].name
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        cell.dateLabelOutlet.text = formatter.string(from: myNewExpense[indexPath.row].date as Date)
        return cell
        

    }
    
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    
            return .delete
       
    }
    
    // MARK: - Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let myNewExpense = realm.objects(NewExpenses.self)
            let currentExpense = myNewExpense[indexPath.row]
            try! realm.write {
                realm.delete(currentExpense)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }

    
}

extension NewExpenceViewController: updateExpenceTableViewDelegate {
    func reloadTableView() {
        newExpenseTableView.reloadData()
    }
    
}

