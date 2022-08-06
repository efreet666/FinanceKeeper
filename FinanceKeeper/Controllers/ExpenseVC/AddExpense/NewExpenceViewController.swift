//
//  ViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 06.08.2022.
//

import UIKit
import RealmSwift

class NewExpenceViewController: UIViewController {

    let realm = try! Realm()
    
    let newExpenseTableView = UITableView()
    let addNewCategoryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newExpenseTableView.dataSource = self
        self.newExpenseTableView.delegate = self
        self.newExpenseTableView.register(UINib(nibName: "NewExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "NewExpenseTableViewCell")
        
        setupView()
    }
    
    private func setupView() {
        
        view.addSubview(newExpenseTableView)
        newExpenseTableView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        
        addNewCategoryButton.setTitle("Добавить расход", for: .normal)
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
        let modalViewController = AddNewExpenseViewController()
        modalViewController.modalPresentationStyle = .popover
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        //modalViewController.delegate = self
        present(modalViewController, animated: true, completion: nil)
    }


}
extension NewExpenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myExpenseCategory = realm.objects(NewExpenses.self)
        print(myExpenseCategory)
        print(myExpenseCategory.count)
        return (myExpenseCategory.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myNewExpense = realm.objects(NewExpenses.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewExpenseTableViewCell", for: indexPath) as! NewExpenseTableViewCell
        cell.dateLabelOutlet.text = "\(myNewExpense[indexPath.row].date)"
        cell.expenseLabelOutlet.text = myNewExpense[indexPath.row].amount
        cell.nameLabelOutlet.text = myNewExpense[indexPath.row].name
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
