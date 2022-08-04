//
//  addExpenceViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 01.08.2022.
//


import UIKit
import RealmSwift

class addExpenceViewController: UIViewController {
    
    weak var delegate : updateExpanceTableViewDelegate?
    
    let incomeTextField = UITextField()
    let addIncomeButton = UIButton()
    
    let newCategory = ExpenseСategory()
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
        let newView = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 650))
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
        incomeTextField.placeholder = "Наименование"
        incomeTextField.tintColor = .gray
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
    
    //MARK: - Add button
    func setupButton() {
        addIncomeButton.setTitle("Добавить категорию расходов", for: .normal)
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
    
    //MARK: - Add new income to Realm
    
    @objc func addNewIncome(button: UIButton) {
        let newCategoryText = incomeTextField.text
        if newCategoryText != "" {
            newCategory.category = newCategoryText ?? ""
            
            try! realm.write {
                realm.add(newCategory)
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
