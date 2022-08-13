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
    
    var currentInterval: dataInterval = .week
    enum dataInterval {
        case week
        case mounth
        case threeMonths
        case all
    }
    
    func change(to index: Int) {
        switch index {
        case 0:
            setupChartData(interval: .week)
            // Get on-disk location of the default Realm
            let realm = try! Realm()
            print("Realm is located at:", realm.configuration.fileURL!)
        case 1:
            setupChartData(interval: .mounth)
        case 2:
            setupChartData(interval: .threeMonths)
        case 3:
            setupChartData(interval: .all)
        default:
            print("default")
        }
        
    }
    
    
    weak var interfaceSegmented: CustomSegmentedControl!{
           didSet{
               interfaceSegmented.setButtonTitles(buttonTitles: ["Week","Month", "3 months", "All"])
               interfaceSegmented.selectorViewColor = .blue
               interfaceSegmented.selectorTextColor = .blue
           }
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           setupCustomSegmentControll()
           
       }

    
    func setupCustomSegmentControll() {
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50), buttonTitle: ["Week","Month", "3 months", "All"])
        codeSegmented.backgroundColor = .clear
        view.addSubview(codeSegmented)
        codeSegmented.delegate = self
        
    }
    // MARK: - Setup charts
    var lineChart = CombinedChartView()

    override func viewWillAppear(_ animated: Bool) {
        setupChartData(interval: currentInterval)
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
    func setupChartData(interval: dataInterval) {
        
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
        var myExpenseResult = realm.objects(NewExpenses.self)
        var myIncomeResult = realm.objects(NewIncome.self)
        
        let dateNow = NSDate(timeIntervalSinceNow: 0)
        let predicateNow = NSPredicate(format: "date < [c]%@", dateNow)
        
        switch interval {
        case .week:
            
            let weekAgo = NSDate(timeIntervalSinceNow: -604800)
            let predicateWeekAgo = NSPredicate(format: "date > [c]%@", weekAgo)
            
            let queryWeek = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateWeekAgo,predicateNow])
            
            myExpenseResult = realm.objects(NewExpenses.self).filter(queryWeek)
            myIncomeResult = realm.objects(NewIncome.self).filter(queryWeek)
        case .mounth:
            let mounthAgo = NSDate(timeIntervalSinceNow: -604800 * 4)
            let predicateMonthAgo = NSPredicate(format: "date > [c]%@", mounthAgo)
            let queryMonth = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateMonthAgo, predicateNow])
            myExpenseResult = realm.objects(NewExpenses.self).filter(queryMonth)
            myIncomeResult = realm.objects(NewIncome.self).filter(queryMonth)
        case .threeMonths:
            let threeMounthAgo = NSDate(timeIntervalSinceNow: -604800 * 4 * 3)
            let predicateThreeMonthAgo = NSPredicate(format: "date > [c]%@", threeMounthAgo)
            let queryThreeMonth = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateThreeMonthAgo, predicateNow])
            myExpenseResult = realm.objects(NewExpenses.self).filter(queryThreeMonth)
            myIncomeResult = realm.objects(NewIncome.self).filter(queryThreeMonth)
        case .all:
            myExpenseResult = realm.objects(NewExpenses.self)
            myIncomeResult = realm.objects(NewIncome.self)
        
        }
        
        var entries = [ChartDataEntry]()
        var dayTotalAmount: Double = 0
        
        for i in 0..<myExpenseResult.count {
            
            let graphableDatesAsDouble = myExpenseResult.map { $0.date.timeIntervalSince1970 }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let dayOfMonth = graphableDatesAsDouble[i]
            
            if i != myExpenseResult.count - 1 {
                
                if formatter.string(from: myExpenseResult[i].date as Date) == formatter.string(from: myExpenseResult[i + 1].date as Date) {
                    
                    dayTotalAmount += Double(myExpenseResult[i].amount) ?? 0
                } else {
                    
                    dayTotalAmount += Double(myExpenseResult[i].amount) ?? 0
                    
                    entries.append(ChartDataEntry(x: dayOfMonth, y: dayTotalAmount))
                    dayTotalAmount = 0
                }
            } else {
                dayTotalAmount += Double(myExpenseResult[i].amount) ?? 0
                entries.append(BarChartDataEntry(x: dayOfMonth, y:  dayTotalAmount))
                dayTotalAmount = 0
            }
            
        }

        let set = LineChartDataSet(entries: entries, label: "Расходы")
        
        set.colors = ChartColorTemplates.pastel()
        set.mode = .linear
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
        
        var incomeEntries = [BarChartDataEntry]()
        var dayTotalIncome: Double = 0
        
        for i in 0..<myIncomeResult.count {
            
            let graphableDatesAsDouble = myExpenseResult.map { $0.date.timeIntervalSince1970 }
            
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
        
        
        lineChart.xAxis.granularity = 1
        lineChart.xAxis.valueFormatter = XAxisNameFormater()
        
        lineChart.data = combinedData
    }
    
    
    
}

