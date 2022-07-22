//
//  ViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 22.07.2022.
//

import UIKit

class IncomeViewController: UIViewController {

    let incomeTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        incomeTableView.translatesAutoresizingMaskIntoConstraints = true
        incomeTableView.center = view.center
        view.addSubview(incomeTableView)
       
    }


}

extension IncomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
    
    
}
