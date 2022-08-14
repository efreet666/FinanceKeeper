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

class ExpenseGraphViewController: UIViewController, ChartViewDelegate, CustomSegmentedControlDelegate  {
    
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
    
    var currentCategory = ""
    
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        lineChart.delegate = self
        
        setupCustomSegmentControll()
        self.title = "График расходов"
        setupView()
        setupChartData(interval: .week)
    }
    
    func setupCustomSegmentControll() {
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50), buttonTitle: ["Week","Month", "3 months", "All"])
        codeSegmented.backgroundColor = .clear
        view.addSubview(codeSegmented)
        codeSegmented.delegate = self
        
    }
    
    func setupView() {
        
        view.addSubview(lineChart)
        
        lineChart.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(340)
            
        }
    }
    
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
        
        let realm = try! Realm()
        var myExpenseResult = realm.objects(NewExpenses.self)
        
        let dateNow = NSDate(timeIntervalSinceNow: 0)
        let predicateNow = NSPredicate(format: "date < [c]%@", dateNow)
        let predicateCategory = NSPredicate(format: "category = [c]%@", currentCategory)
        switch interval {
        case .week:
            
            let weekAgo = NSDate(timeIntervalSinceNow: -604800)
            let predicateWeekAgo = NSPredicate(format: "date > [c]%@", weekAgo)
            
            let queryWeek = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateWeekAgo, predicateNow, predicateCategory])
            
            myExpenseResult = realm.objects(NewExpenses.self).filter(queryWeek)
            print(myExpenseResult)
        case .mounth:
            let mounthAgo = NSDate(timeIntervalSinceNow: -604800 * 4)
            let predicateMonthAgo = NSPredicate(format: "date > [c]%@", mounthAgo)
            let queryMonth = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateMonthAgo, predicateNow, predicateCategory])
            myExpenseResult = realm.objects(NewExpenses.self).filter(queryMonth)
            print(myExpenseResult)
        case .threeMonths:
            let threeMounthAgo = NSDate(timeIntervalSinceNow: -604800 * 4 * 3)
            let predicateThreeMonthAgo = NSPredicate(format: "date > [c]%@", threeMounthAgo)
            let queryThreeMonth = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateThreeMonthAgo, predicateNow, predicateCategory])
            myExpenseResult = realm.objects(NewExpenses.self).filter(queryThreeMonth)
            print(myExpenseResult)
        case .all:
            myExpenseResult = realm.objects(NewExpenses.self).filter(predicateCategory)
            print(myExpenseResult)
            
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
        
        let set = LineChartDataSet(entries: entries, label: "\(currentCategory)")
        
        
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
