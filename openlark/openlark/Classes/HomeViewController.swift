//
//  HomeViewController.swift
//  openlark
//
//  Created by AlexChen on 2021/09/22.
//

import UIKit

class HomeViewController: UIViewController {

    let checkinDate = "2021-09-23 17:21:00"   // year-month-day hour:minute:second
    var week = "week-39"
    let delayTime = 10
    var larkIsOpen: ((_ result: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        loadSchemeConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let result = performCheckIn()
//        if result == false {
//            // retry check-in after a few second
//        }
//
//        self.larkIsOpen = { (result) in
//            switch result {
//            case true:
//                // check-in successful
//                break
//            case false:
//                // check-in failed
//                break
//            }
//        }
    }
    

    func performCheckIn() -> Bool {
        let checkInTime = getTimeIntervalFrom(checkinDate)
        let timeInterval = getCurrentDate()
        let differ = timeInterval - checkInTime
        
        guard differ > delayTime else {
            return false
        }
        openLark()
        return true
    }
}

extension HomeViewController {
    
    func getCurrentDate() -> Int {
        let timeInterval = Int(Date().timeIntervalSince1970)
        return timeInterval
    }
    
    func loadSchemeConfig() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        let today = formatter.string(from: Date())
        print(" -> today = \(today)")
        
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let data = NSDictionary(contentsOfFile: path),
              let dataArr = data.object(forKey: week) as? Array<Any> else {
            
            return
        }
        
        for item in dataArr {
            if let item = item as? Dictionary<String, String>,
               let date = item["date"],
               let time = item["time"],
               item["date"] == today {
                
                let checkInTime = ConfigModel.init(date: date, time: time)
                print(" -> checkInTime = \(checkInTime)")
                break
            }
        }
    }
    
    func getTimeIntervalFrom(_ string: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        guard let date = formatter.date(from: string) else {
            return Int(Date().timeIntervalSince1970)
        }
        
        let timeInterval = Int(date.timeIntervalSince1970)
        return timeInterval
    }
    
    func openLark() {
        guard let url = URL(string: "feishu://") else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: { [self] (result) in
            larkIsOpen?(result)
        })
    }
}
