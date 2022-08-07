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
    let openGraphExpenseVutton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newExpenseTableView.dataSource = self
        self.newExpenseTableView.delegate = self
        self.newExpenseTableView.register(UINib(nibName: "NewExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "NewExpenseTableViewCell")
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        print(currentCategory)
        self.navigationController?.title = currentCategory
    }
    private func setupView() {
        
        view.addSubview(newExpenseTableView)
        newExpenseTableView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
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
        
        
    }
    
    @objc func openAddSubview() {
        let modalViewController = AddNewExpenseViewController()
        modalViewController.modalPresentationStyle = .popover
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modalViewController.newExpenseCurrentCategory = currentCategory
        modalViewController.delegate = self
        present(modalViewController, animated: true, completion: nil)
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

