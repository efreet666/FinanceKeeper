//
//  IncomeModel.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 23.07.2022.
//

import Foundation
import RealmSwift

class Income: Object {
    @objc dynamic var name = ""
    @objc dynamic var category = false
    @objc dynamic var date: NSDate = NSDate(timeIntervalSinceNow: 0)
}
