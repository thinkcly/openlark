//
//  HomeViewController.swift
//  openlark
//
//  Created by AlexChen on 2021/09/22.
//

import UIKit

class HomeViewController: UIViewController {

    var checkinTime = ""   // year-month-day hour:minute:second
    let week = "week-39"
    let delay = 0
    var timerCount: Double = 0
    let loopInterval: TimeInterval = 10
    var larkIsOpen: ((_ result: Bool) -> Void)?
    var checkInSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startTimer()
        
        self.larkIsOpen = { [self] (result) in
            switch result {
            case true:
                checkInSuccess = true
                print(" -> Lark: ALready opened")
            case false:
                print("Can not open lark via 'Feishu://'. Maybe lark not install on this device.")
            }
        }
    }
    
    func startTimer() {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: loopInterval)
        print(" -> Loop: Start now")
        
        timer.setEventHandler(handler: { [self] in
            print(" -> Loop: Already start")
            timerCount += 0.01
            if checkInSuccess {
                print(" -> Loop: Canceled cause check-in was success")
                timer.cancel()
            } else {
                DispatchQueue.main.async {
                    loadSchemeConfig()
                    performCheckIn()
                }
            }
        })
        timer.resume()
    }
    
    func performCheckIn() {
        guard !checkinTime.isEmpty else {
            return
        }
        let target = getCheckInTimeStampFrom(checkinTime)
        let now = getCurrentTimeStamp()
        let differ = now - target
        
        guard differ > delay else {
            return
        }
        openLark()
    }
}

extension HomeViewController {
    
    func getCurrentTimeStamp() -> Int {
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
            if let item = item as? Dictionary<String, Any>,
               let date = item["date"] as? String,
               let time = item["time"] as? String,
               let status = item["alreadyCheckIn"] as? Bool,
               date == today,
               status == false {
                
                let checkinDate = ConfigModel.init(date: date, time: time, alreadyCheckIn: status)
                checkinTime = checkinDate.time
                print(" -> checkInTime = \(checkinTime)")
                break
            }
        }
    }
    
    func getCheckInTimeStampFrom(_ string: String) -> Int {
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
