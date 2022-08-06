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
        self.categoryTableView.dataSource = self
        self.categoryTableView.delegate = self
        self.categoryTableView.register(UINib(nibName: "ExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpenseTableViewCell")
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
        let myExpenseCategory = realm.objects(ExpenseСategory.self)
        print(myExpenseCategory)
        print(myExpenseCategory.count)
        return (myExpenseCategory.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myExpenseCategory = realm.objects(ExpenseСategory.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as! ExpenseTableViewCell
        cell.categoryLabelOutlet.text = myExpenseCategory[indexPath.row].category
        return cell
        

    }
    
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    
            return .delete
       
    }
    
    // MARK: - Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
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
