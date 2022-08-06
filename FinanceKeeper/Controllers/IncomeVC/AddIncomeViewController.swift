//
//  AddIncomeViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 23.07.2022.
//

import UIKit
import RealmSwift

class AddIncomeViewController: UIViewController {
    
    weak var delegate : updateIncomeTableViewDelegate?
    
    let incomeTextField = UITextField()
    let incomeCategoryTextField = UITextField()
    let addIncomeButton = UIButton()
    
    let myIncome = NewIncome()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModalView()
        setupTextField()
        setupButton()
        incomeTextField.becomeFirstResponder()
    }
    
    //MARK: - Modal View
    
    func setupModalView(){
        view.backgroundColor = UIColor.black
        view.isOpaque = false
        let newView = UIView(frame: CGRect(x: 0, y: 250, width: self.view.frame.width, height: 800))
        newView.backgroundColor = .systemBackground
        newView.layer.cornerRadius = 20
        
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.view.addSubview(newView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - TextField
    
    func setupTextField() {
        
        incomeTextField.backgroundColor = .white
        incomeTextField.textColor = .black
        incomeTextField.tintColor = .blue
        incomeTextField.font = UIFont.systemFont(ofSize: 15)
        incomeTextField.borderStyle = UITextField.BorderStyle.roundedRect
        incomeTextField.autocorrectionType = UITextAutocorrectionType.no
        incomeTextField.keyboardType = UIKeyboardType.numberPad
        incomeTextField.returnKeyType = UIReturnKeyType.done
        incomeTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        incomeTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        incomeTextField.attributedPlaceholder = NSAttributedString(
            string: "Сумма",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubview(incomeTextField)
        
        incomeTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(460)
            make.height.equalTo(45)
        }
        
        
        incomeCategoryTextField.backgroundColor = .white
        incomeCategoryTextField.textColor = .black
        incomeCategoryTextField.tintColor = .blue
        incomeCategoryTextField.font = UIFont.systemFont(ofSize: 15)
        incomeCategoryTextField.borderStyle = UITextField.BorderStyle.roundedRect
        incomeCategoryTextField.autocorrectionType = UITextAutocorrectionType.no
        incomeCategoryTextField.keyboardType = UIKeyboardType.alphabet
        incomeCategoryTextField.returnKeyType = UIReturnKeyType.done
        incomeCategoryTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        incomeCategoryTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        incomeCategoryTextField.delegate = self
        incomeCategoryTextField.attributedPlaceholder = NSAttributedString(
            string: "Источник дохода",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubview(incomeCategoryTextField)
        
        incomeCategoryTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(400)
            make.height.equalTo(45)
        }
    }
   
    //MARK: - Add button
    func setupButton() {
        addIncomeButton.setTitle("Добавить доход", for: .normal)
        addIncomeButton.setTitleColor(.white, for: .normal)
        addIncomeButton.setTitleColor(.gray, for: .selected)
        addIncomeButton.backgroundColor = .blue
        addIncomeButton.layer.cornerRadius = 12
        self.view.addSubview(addIncomeButton)
        addIncomeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(incomeCategoryTextField).inset(70)
            make.height.equalTo(45)
        }
        addIncomeButton.addTarget(self, action: #selector(addNewExpense(button:)), for: .touchUpInside)
    }
    
    //MARK: - Add new income to Realm
    
    @objc func addNewExpense(button: UIButton) {
        let newIncomeText = incomeTextField.text
        let newIncomeCategoryText = incomeCategoryTextField.text
        if newIncomeText != "" && newIncomeCategoryText != ""{
            myIncome.category = newIncomeCategoryText ?? ""
            myIncome.amount = newIncomeText ?? ""
            myIncome.date = NSDate(timeIntervalSinceNow: 0)
            
            try! realm.write {
                realm.add(myIncome)
            }
            delegate?.reloadTableView()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Dismiss view with gesture
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddIncomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let newIncomeText = incomeTextField.text
        let newIncomeCategoryText = incomeCategoryTextField.text
        if newIncomeText != "" && newIncomeCategoryText != ""{
            myIncome.category = newIncomeCategoryText ?? ""
            myIncome.amount = newIncomeText ?? ""
            myIncome.date = NSDate(timeIntervalSinceNow: 0)
            
            try! realm.write {
                realm.add(myIncome)
            }
            delegate?.reloadTableView()
        }
        dismiss(animated: true, completion: nil)
        return true
    }
}
