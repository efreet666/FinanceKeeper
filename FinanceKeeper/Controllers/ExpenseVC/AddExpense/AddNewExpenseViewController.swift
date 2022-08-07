//
//  AddNewExpenseViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 06.08.2022.
//

import UIKit
import RealmSwift

class AddNewExpenseViewController: UIViewController {
    
    let expenseTextField = UITextField()
    let expenseNameTextField = UITextField()
    let addExpenseButton = UIButton()
    
    var newExpenseCurrentCategory = ""
    
    let myNewExpense = NewExpenses()
    let realm = try! Realm()
    
    weak var delegate : updateExpenceTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTextField.becomeFirstResponder()
        setupViews()
    }
    
    func setupViews() {
        setupModalView()
        setupTextField()
        setupButton()
    }
    
    func setupModalView() {
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
        expenseTextField.tintColor = .blue
        expenseTextField.font = UIFont.systemFont(ofSize: 15)
        expenseTextField.borderStyle = UITextField.BorderStyle.roundedRect
        expenseTextField.autocorrectionType = UITextAutocorrectionType.no
        expenseTextField.keyboardType = UIKeyboardType.numberPad
        expenseTextField.returnKeyType = UIReturnKeyType.done
        expenseTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        expenseTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        expenseTextField.attributedPlaceholder = NSAttributedString(
            string: "Сумма",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubview(expenseTextField)
        
        expenseTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(440)
            make.height.equalTo(45)
        }
        
        
        expenseNameTextField.backgroundColor = .white
        expenseNameTextField.textColor = .black
        expenseNameTextField.tintColor = .blue
        expenseNameTextField.font = UIFont.systemFont(ofSize: 15)
        expenseNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        expenseNameTextField.autocorrectionType = UITextAutocorrectionType.no
        expenseNameTextField.keyboardType = UIKeyboardType.alphabet
        expenseNameTextField.returnKeyType = UIReturnKeyType.done
        expenseNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        expenseNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        expenseNameTextField.delegate = self
        expenseNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Наименование",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubview(expenseNameTextField)
        
        expenseNameTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(380)
            make.height.equalTo(45)
        }
    }
    
    //MARK: - Add button
    func setupButton() {
        addExpenseButton.setTitle("Добавить расход", for: .normal)
        addExpenseButton.setTitleColor(.white, for: .normal)
        addExpenseButton.setTitleColor(.gray, for: .selected)
        addExpenseButton.backgroundColor = .blue
        addExpenseButton.layer.cornerRadius = 12
        self.view.addSubview(addExpenseButton)
        
        addExpenseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(expenseNameTextField).inset(70)
            make.height.equalTo(45)
        }
        addExpenseButton.addTarget(self, action: #selector(addNewExpense(button:)), for: .touchUpInside)
    }

    @objc func addNewExpense(button: UIButton) {
        let newExpenseAmountText = expenseTextField.text
        let expenseNameText = expenseNameTextField.text
        if newExpenseAmountText != "" && expenseNameText != "" {
            myNewExpense.category = newExpenseCurrentCategory
            myNewExpense.amount = newExpenseAmountText ?? ""
            myNewExpense.name = expenseNameText ?? ""
            myNewExpense.date = NSDate(timeIntervalSinceNow: 187000)
            
            try! realm.write {
                realm.add(myNewExpense)
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
extension AddNewExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let newExpenseAmountText = expenseTextField.text
        let expenseNameText = expenseNameTextField.text
        if newExpenseAmountText != "" && expenseNameText != "" {
            myNewExpense.category = "-"
            myNewExpense.amount = newExpenseAmountText ?? ""
            myNewExpense.name = expenseNameText ?? ""
            
            try! realm.write {
                realm.add(myNewExpense)
            }
            delegate?.reloadTableView()
            
            dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
        return true
    }
}
