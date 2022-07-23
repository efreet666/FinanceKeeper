//
//  AddIncomeViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 23.07.2022.
//

import UIKit
import RealmSwift

class AddIncomeViewController: UIViewController {
    
    weak var delegate : updateTableViewDelegate?
    
    let incomeTextField = UITextField()
    let addIncomeButton = UIButton()
    
    let myIncome = Income()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupButton()
        
        
    }
    func setupTextField() {
        incomeTextField.backgroundColor = .white
        incomeTextField.textColor = .black
        incomeTextField.placeholder = "Enter text here"
        incomeTextField.font = UIFont.systemFont(ofSize: 15)
        incomeTextField.borderStyle = UITextField.BorderStyle.roundedRect
        incomeTextField.autocorrectionType = UITextAutocorrectionType.no
        incomeTextField.keyboardType = UIKeyboardType.numberPad
        incomeTextField.returnKeyType = UIReturnKeyType.done
        incomeTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        incomeTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view.addSubview(incomeTextField)
        incomeTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
    }
    
    func setupButton() {
        addIncomeButton.setTitle("Добавить доход", for: .normal)
        addIncomeButton.setTitleColor(.white, for: .normal)
        addIncomeButton.setTitleColor(.gray, for: .selected)
        addIncomeButton.backgroundColor = .blue
        addIncomeButton.layer.cornerRadius = 12
        self.view.addSubview(addIncomeButton)
        addIncomeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(incomeTextField).inset(70)
            make.height.equalTo(45)
        }
        addIncomeButton.addTarget(self, action: #selector(addNewIncome(button:)), for: .touchUpInside)
    }
    
    @objc func addNewIncome(button: UIButton) {
        
        let newIncomeText = incomeTextField.text
        
        myIncome.name = newIncomeText ?? ""
        myIncome.date = NSDate(timeIntervalSinceNow: 0)
    
        try! realm.write {
            realm.add(myIncome)
        }
        delegate?.reloadTableView()
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
