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

class NewExpense: Object {
    @objc dynamic var amount = ""
    @objc dynamic var category = ""
    @objc dynamic var date: NSDate = NSDate(timeIntervalSinceNow: 0)
}

