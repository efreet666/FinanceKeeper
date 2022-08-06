//
//  IncomeModel.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 23.07.2022.
//

import Foundation
import RealmSwift

class NewIncome: Object {
    @objc dynamic var amount = ""
    @objc dynamic var category = ""
    @objc dynamic var date: NSDate = NSDate(timeIntervalSinceNow: 0)
}

class NewExpenses: Object {
    @objc dynamic var amount = ""
    @objc dynamic var name = ""
    @objc dynamic var category = ""
    @objc dynamic var date: NSDate = NSDate(timeIntervalSinceNow: 0)
}

class ExpenseСategory: Object {
    @objc dynamic var category = ""
}

