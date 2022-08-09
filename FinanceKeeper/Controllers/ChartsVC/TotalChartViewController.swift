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

class TotalChartViewController: UIViewController, ChartViewDelegate, CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        switch index {
        case 0:
            print("1")
            // In develop...
            
            let realm = try! Realm()
            var weekAgo = NSDate(timeIntervalSinceNow: -604800)
            var tommorow = NSDate(timeIntervalSinceNow: 86400)
            let predicate = NSPredicate(format: "date > [c]%@", NSDate(timeIntervalSinceNow: -604800))
            let myResult = realm.objects(NewExpenses.self).filter(predicate)
            print(myResult)

            
            print(myResult)
        case 1:
            print("2")
        default:
            print("3")
        }
        
    }
    
    
    weak var interfaceSegmented: CustomSegmentedControl!{
           didSet{
               interfaceSegmented.setButtonTitles(buttonTitles: ["Week","Month","All"])
               interfaceSegmented.selectorViewColor = .blue
               interfaceSegmented.selectorTextColor = .blue
           }
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           setupCustomSegmentControll()
           
       }

    
    func setupCustomSegmentControll() {
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50), buttonTitle: ["Week","Month","All"])
        codeSegmented.backgroundColor = .clear
        view.addSubview(codeSegmented)
        codeSegmented.delegate = self
        
    }
    // MARK: - Setup charts
    var lineChart = CombinedChartView()

    override func viewWillAppear(_ animated: Bool) {
        setupChartData()
        setupView()
    }
    
    func setupView() {
        
        view.addSubview(lineChart)
        
        lineChart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(250)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(340)
            
        }
    }
    
//MARK: - Setup Chart
    func setupChartData() {
        
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
        
        //MARK: - Expense data
        let realm = try! Realm()
        let myResult = realm.objects(NewExpenses.self)
        
        var entries = [ChartDataEntry]()
        var dayTotalAmount: Double = 0
        
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
                    
                    entries.append(ChartDataEntry(x: dayOfMonth, y: dayTotalAmount))
                    dayTotalAmount = 0
                }
            } else {
                dayTotalAmount += Double(myResult[i].amount) ?? 0
                entries.append(BarChartDataEntry(x: dayOfMonth, y:  dayTotalAmount))
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
        
        //MARK: - Income data
        let myIncomeResult = realm.objects(NewIncome.self)
        
        var incomeEntries = [BarChartDataEntry]()
        var dayTotalIncome: Double = 0
        
        for i in 0..<myIncomeResult.count {
            
            let graphableDatesAsDouble = myResult.map { $0.date.timeIntervalSince1970 }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            
            let dayOfMonth = graphableDatesAsDouble[i]
            
            if i != myIncomeResult.count - 1 {
                
                if formatter.string(from: myIncomeResult[i].date as Date) == formatter.string(from: myIncomeResult[i + 1].date as Date) {
                    
                    dayTotalIncome += Double(myIncomeResult[i].amount) ?? 0
                } else {
                    
                    dayTotalIncome += Double(myIncomeResult[i].amount) ?? 0
                    
                    incomeEntries.append(BarChartDataEntry(x: dayOfMonth, y:  dayTotalIncome))
                    dayTotalIncome = 0
                }
            } else {
                dayTotalIncome += Double(myIncomeResult[i].amount) ?? 0
                incomeEntries.append(BarChartDataEntry(x: dayOfMonth, y:  dayTotalIncome))
                dayTotalIncome = 0
            }
            
        }
        let IncomeSet = BarChartDataSet(entries: incomeEntries, label: "Доходы")
        
        IncomeSet.colors = ChartColorTemplates.material()
        IncomeSet.barBorderWidth = 10
        IncomeSet.barBorderColor = .red
        IncomeSet.highlightColor = .white
        
        //MARK: - Setup Combined Chart
        let combinedData: CombinedChartData = CombinedChartData()
        combinedData.lineData = LineChartData(dataSet: set)
        combinedData.barData = BarChartData(dataSet: IncomeSet)
        
        data.setDrawValues(false)
        
        lineChart.xAxis.valueFormatter = XAxisNameFormater()
        lineChart.xAxis.granularity = 1.0

        lineChart.data = combinedData
    }
    
    
    
}

