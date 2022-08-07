//
//  ExpenseGraphViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 07.08.2022.
//

import UIKit
import Charts
import SnapKit
import RealmSwift

class ExpenseGraphViewController: UIViewController, ChartViewDelegate {

    var currentCategory = ""
    
    
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        
        lineChart.delegate = self
       
    }
    
    override func viewDidLayoutSubviews() {
        setupChartData()
        setupView()
    }
    func setupView() {
        
        view.addSubview(lineChart)
        
        lineChart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(300)
            
        }
    }

    func setupChartData() {
        let predicate = NSPredicate(format: "category BEGINSWITH [c]%@", currentCategory)
        let realm = try! Realm()
        let myResult = realm.objects(NewExpenses.self).filter(predicate)
        
        
        
        var entries = [BarChartDataEntry]()
        
        for i in 0..<myResult.count {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let dayOfMonth = formatter.string(from: myResult[i].date as Date)
            entries.append(BarChartDataEntry(x: Double(dayOfMonth) ?? 0 , y:  Double(myResult[i].amount) ?? 0))
        }
        
        
        let set = LineChartDataSet(entries: entries)
        

        set.colors = ChartColorTemplates.colorful()
        let data = LineChartData(dataSet: set)
        
        lineChart.data = data
    }
   

}
