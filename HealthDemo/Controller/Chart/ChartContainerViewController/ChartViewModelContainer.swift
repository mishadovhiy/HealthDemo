//
//  ChartContainerViewModel.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit

extension ChartContainerViewController {
    struct ChartViewModelContainer {
        let numberOfRows = 3
        var verticalChartCount = 30
        var animateChart:Bool = true

        var tableData:[CalendarModel] = []

        var monthChanged:(_ new:[CalendarModel])->()

        var middleDate:CalendarData? {
            didSet {
                if let val = middleDate {
                    monthChanged(createCalendarData(val))
                }
            }
        }
        
        mutating func scrollIndxUpdated(_ index:Int) {
            middleDate = .init(year: tableData[index].year,
                                    month: tableData[index].month)
        }
        
        mutating func createCalendarData(_ middle:CalendarData) -> [CalendarModel] {
            var new:[CalendarModel] = []
            for i in 0..<3 {
                let neww:CalendarModel = .init(self.newMonth(current: middle, i: i))
                new.append(neww)
            }
            self.tableData.removeAll()
            self.tableData = new

            return new
        }
        
        private func newMonth(current:CalendarData, i:Int) -> CalendarData {
            let month = current.month + (i - 1)
            if month >= 1 && month <= 12 {
                return .init(year: current.year, month: month)
            } else {
                let minus = month < 1
                return .init(year: current.year + (minus ? (-1) : 1),
                             month: !minus ? 1 : 12)
            }
        }
    }
    

    struct InitialChartData {
        var healthKey:String
        
        var healthKeyData:TodayAllHealthData?
        var healthData:[Date:Double] = [:]
        var healthValues:[Double] = []
        
        init() {
            self.healthKey = "?"
        }
        public static func with(
          _ populator: (inout Self) throws -> ()
        ) rethrows -> Self {
            var message = Self()
          try populator(&message)
          return message
        }
    }
}

struct CalendarModel {
    
    init(_ data:CalendarData) {
        self.year = data.year
        self.month = data.month
        self.days = getDays()
        
    }
    
    var description:String {
        return "year:\(self.year), month:\(self.month), \ndays:\(self.days)"
    }
    
    
    var year = 1996
    var month = 11
    
    var days = [0]
    var daystoWeekStart = 0
    
    var upToFour = (0,0)
    
    lazy var today:DateComponents = {
        return getToday
    }()
    
    
    
    mutating func getDays() -> [Int]  {
        daystoWeekStart = 0
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        days.removeAll()
        
        var resultDays:[Int] = []
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = "\(year)-\(makeTwo(month))-02"
        let datee = formatter.date(from: strDate)
        let calendarr = Calendar(identifier: .gregorian)
        let weekNumber = calendarr.component(.weekday, from: datee ?? Date())-3
        
        let weekRes = weekNumber < 0 ? 7 + weekNumber : weekNumber
        daystoWeekStart = weekRes
        for _ in 0..<weekRes{
            resultDays.append(0)
        }
        for i in 0..<numDays {
            resultDays.append(i+1)
        }
        self.days = resultDays
        return resultDays
        
        /*DispatchQueue.main.async {
         self.monthTF.text = "\(self.returnMonth(self.month)), \(self.year)"
         self.daysLoaded()
         }*/
        
        
    }
    
    
    var getToday: DateComponents {
        let now = Date()
        return now.dateComponents
    }
    
    func makeTwo(_ int: Int?) -> String {
        if let n = int {
            return n <= 9 ? "0\(n)" : "\(n)"
        } else {
            return "00"
        }
    }
    
    func returnMonth(_ month: Int) -> String {
        
        return "\(month)"
    }
    
    mutating func setYear() {
        if month == 13 {
            month = 1
            year = year + 1
        }
        if month == 0 {
            month = 12
            year = year - 1
        }
    }
    
    
    mutating func setMonth(_ month:Int) {
        self.month = month//sender.tag == 0 ? model.month - 1 : model.month + 1
        self.setYear()
        self.days = []//self.getDays()
    }
}

struct CalendarData:Hashable, Identifiable {
    var id: ObjectIdentifier? {
        return nil
    }
    
    let year:Int
    let month:Int
    
    var identifier: String {
        return UUID().uuidString
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: CalendarData, rhs: CalendarData) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.identifier == rhs.identifier
    }
}
