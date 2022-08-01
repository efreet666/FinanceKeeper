//
//  ExpenseViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 01.08.2022.
//

import UIKit

class ExpenseViewController: UIViewController {

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
        
    }
}
