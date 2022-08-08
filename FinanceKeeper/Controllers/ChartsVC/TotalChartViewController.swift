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

    var lineChart = CombinedChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChart.rightAxis.enabled = false
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.setLabelCount(6, force: false)
        lineChart.animate(yAxisDuration: 3, easingOption: .easeOutQuart)
        lineChart.xAxis.granularity = 1
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

        var entries = [ChartDataEntry]()
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

                    entries.append(ChartDataEntry(x: Double(dayOfMonth) ?? 0, y: dayTotalAmount))
                    dayTotalAmount = 0
                }
            } else {
                dayTotalAmount += Double(myResult[i].amount) ?? 0
                entries.append(BarChartDataEntry(x: Double(dayOfMonth) ?? 0 , y:  dayTotalAmount))
                dayTotalAmount = 0
            }

        }


        let set = LineChartDataSet(entries: entries, label: "Расходы")


        set.colors = ChartColorTemplates.pastel()
        set.mode = .cubicBezier
        set.drawCirclesEnabled = true
        set.drawCircleHoleEnabled = true
        set.circleHoleColor = .white
        set.lineWidth = 3
        set.setColor(.blue)
        set.drawFilledEnabled = true
        set.drawVerticalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        set.fillColor = .white
        set.fillAlpha = 0.3

        let data = LineChartData(dataSet: set)
        data.setDrawValues(true)
        
        //new
        let myIncomeResult = realm.objects(NewIncome.self)
        
        var incomeEntries = [BarChartDataEntry]()
        var dayTotalIncome: Double = 0
        
        for i in 0..<myIncomeResult.count {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let dayOfMonth = formatter.string(from: myIncomeResult[i].date as Date)
           
            if i != myIncomeResult.count - 1 {
                
                if formatter.string(from: myIncomeResult[i].date as Date) == formatter.string(from: myIncomeResult[i + 1].date as Date) {
                    
                    dayTotalIncome += Double(myIncomeResult[i].amount) ?? 0
                } else {
                    
                    dayTotalIncome += Double(myIncomeResult[i].amount) ?? 0
                    
                    incomeEntries.append(BarChartDataEntry(x: Double(dayOfMonth) ?? 0 , y:  dayTotalIncome))
                    dayTotalIncome = 0
                }
            } else {
                dayTotalIncome += Double(myIncomeResult[i].amount) ?? 0
                incomeEntries.append(BarChartDataEntry(x: Double(dayOfMonth) ?? 0 , y:  dayTotalIncome))
                dayTotalIncome = 0
            }
                        
        }
        let IncomeSet = BarChartDataSet(entries: incomeEntries, label: "Доходы")
        
        IncomeSet.colors = ChartColorTemplates.material()
        IncomeSet.barBorderWidth = 1
        IncomeSet.barBorderColor = .red
        IncomeSet.highlightColor = .white

        //let a: [String] = Array["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", 11", "2"]
        let combinedData: CombinedChartData = CombinedChartData()
        combinedData.lineData = LineChartData(dataSet: set)
        combinedData.barData = BarChartData(dataSet: IncomeSet)
        
        data.setDrawValues(false)
        
        lineChart.data = combinedData
    }

  

}
