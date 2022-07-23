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
        
        
        view.backgroundColor = UIColor.black
        view.isOpaque = false
        let newView = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 800))
        newView.backgroundColor = .systemBackground
        newView.layer.cornerRadius = 20
        
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        // self.view is now a transparent view, so now I add newView to it and can size it however, I like.
        
        self.view.addSubview(newView)
        
        
        // works without the tap gesture just fine (only dragging), but I also wanted to be able to tap anywhere and dismiss it, so I added the gesture below
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
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
            make.bottom.equalToSuperview().inset(400)
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
        if newIncomeText != "" {
            myIncome.name = newIncomeText ?? ""
            myIncome.date = NSDate(timeIntervalSinceNow: 0)
            
            try! realm.write {
                realm.add(myIncome)
            }
            delegate?.reloadTableView()
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    //
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
}
