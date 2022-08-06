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
    
    let expenseTextField = UITextField()
    
    
    let addExpenseButton = UIButton()
    
    let newCategory = ExpenseСategory()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModalView()
        setupTextField()
        setupButton()
        expenseTextField.becomeFirstResponder()
    }
    
    //MARK: - Modal View
    
    func setupModalView(){
        view.backgroundColor = UIColor.black
        view.isOpaque = false
        let newView = UIView(frame: CGRect(x: 0, y: 280, width: self.view.frame.width, height: 670))
        newView.backgroundColor = .systemBackground
        newView.layer.cornerRadius = 20
        
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

        self.view.addSubview(newView)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - TextField
    
    func setupTextField() {
        expenseTextField.backgroundColor = .white
        expenseTextField.textColor = .black
        expenseTextField.placeholder = "Наименование"
        expenseTextField.tintColor = .gray
        expenseTextField.font = UIFont.systemFont(ofSize: 15)
        expenseTextField.borderStyle = UITextField.BorderStyle.roundedRect
        expenseTextField.autocorrectionType = UITextAutocorrectionType.no
        expenseTextField.returnKeyType = UIReturnKeyType.done
        expenseTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        expenseTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view.addSubview(expenseTextField)
        
        expenseTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(420)
            make.height.equalTo(45)
        }
    }
    
    //MARK: - Add button
    func setupButton() {
        addExpenseButton.setTitle("Добавить категорию расходов", for: .normal)
        addExpenseButton.setTitleColor(.white, for: .normal)
        addExpenseButton.setTitleColor(.gray, for: .selected)
        addExpenseButton.backgroundColor = .blue
        addExpenseButton.layer.cornerRadius = 12
        self.view.addSubview(addExpenseButton)
        
        addExpenseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(expenseTextField).inset(70)
            make.height.equalTo(45)
        }
        addExpenseButton.addTarget(self, action: #selector(addNewExpense(button:)), for: .touchUpInside)
    }
    
    //MARK: - Add new income to Realm
    
    @objc func addNewExpense(button: UIButton) {
        let newCategoryText = expenseTextField.text
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
