//
//  TotalChartViewController.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 07.08.2022.
//

import UIKit
import Charts
import SnapKit
import RealmSwift

class TotalChartViewController: UIViewController, ChartViewDelegate {

    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChart.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        let realm = try! Realm()
        let myResult = realm.objects(NewExpenses.self)
        
        var entries = [BarChartDataEntry]()
        var dayTotalAmount: Double = 0
        
        for i in 0..<myResult.count {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let dayOfMonth = formatter.string(from: myResult[i].date as Date)
           
            if i != myResult.count - 1 {
                
                if formatter.string(from: myResult[i].date as Date) == formatter.string(from: myResult[i + 1].date as Date) {
                    
                    dayTotalAmount += Double(myResult[i].amount) ?? 0
                } else {
                    
                    dayTotalAmount += Double(myResult[i].amount) ?? 0
                    
                    entries.append(BarChartDataEntry(x: Double(dayOfMonth) ?? 0 , y:  dayTotalAmount))
                    dayTotalAmount = 0
                }
            } else {
                dayTotalAmount += Double(myResult[i].amount) ?? 0
                entries.append(BarChartDataEntry(x: Double(dayOfMonth) ?? 0 , y:  dayTotalAmount))
                dayTotalAmount = 0
            }
                        
        }
        
        
        let set = LineChartDataSet(entries: entries, label: "Что-то нужно")
        

        set.colors = ChartColorTemplates.pastel()
        set.mode = .horizontalBezier
        let data = LineChartData(dataSet: set)
        
        lineChart.data = data
    }

  

}
