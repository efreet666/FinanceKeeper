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
    
    @IBAction func addNewIncomeButton(_ sender: Any) {
        segueToAddIncomeVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    //MARK: - setupTableView
    func setupTableView() {
        incomeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        
        view.addSubview(incomeTableView)
        incomeTableView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    func segueToAddIncomeVC() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = storyboard.instantiateViewController(withIdentifier: "AddIncomeViewController")
//
//                if let presentationController = viewController.presentationController as? UISheetPresentationController {
//                    presentationController.detents = [.medium()]
//                    presentationController.prefersGrabberVisible = true
//                    presentationController.preferredCornerRadius = 32
//                }
//
//                self.present(viewController, animated: true)
        
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
    
    
}

extension IncomeViewController: updateTableViewDelegate {
    func reloadTableView() {
        incomeTableView.reloadData()
    }
}
