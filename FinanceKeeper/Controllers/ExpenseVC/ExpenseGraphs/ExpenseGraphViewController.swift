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
        
        
        self.title = "График расходов"
    }
    
    override func viewDidLayoutSubviews() {
        setupChartData()
        setupView()
    }
    func setupView() {
        
        view.addSubview(lineChart)
        
        lineChart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(340)
            
        }
    }

    func setupChartData() {
        let predicate = NSPredicate(format: "category BEGINSWITH [c]%@", currentCategory)
        let realm = try! Realm()
        let myResult = realm.objects(NewExpenses.self).filter(predicate)
        
        var entries = [BarChartDataEntry]()
        var dayTotalAmount: Double = 0
        
        //MARK: - Total expense per day
        for i in 0..<myResult.count {
            
            let graphableDatesAsDouble = myResult.map { $0.date.timeIntervalSince1970 }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let dayOfMonth = graphableDatesAsDouble[i]
           
            if i != myResult.count - 1 {
                
                if formatter.string(from: myResult[i].date as Date) == formatter.string(from: myResult[i + 1].date as Date) {
                    
                    dayTotalAmount += Double(myResult[i].amount) ?? 0
                } else {
                    
                    dayTotalAmount += Double(myResult[i].amount) ?? 0
                    
                    entries.append(BarChartDataEntry(x: dayOfMonth , y:  dayTotalAmount))
                    dayTotalAmount = 0
                }
            } else {
                dayTotalAmount += Double(myResult[i].amount) ?? 0
                entries.append(BarChartDataEntry(x: dayOfMonth , y:  dayTotalAmount))
                dayTotalAmount = 0
            }
                        
        }
        
        
        let set = LineChartDataSet(entries: entries, label: "\(currentCategory)")
        
        set.colors = ChartColorTemplates.pastel()
        set.mode = .horizontalBezier
        let data = LineChartData(dataSet: set)
     
        lineChart.xAxis.valueFormatter = XAxisNameFormater()
        lineChart.xAxis.granularity = 1.0
        lineChart.data = data
    }
   

}

final class XAxisNameFormater: NSObject, AxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM"

        return formatter.string(from: Date(timeIntervalSince1970: value))
    }

}
