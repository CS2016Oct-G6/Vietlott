//
//  TodayViewController.swift
//  VietlottWidget
//
//  Created by Liem Ly Quan on 11/24/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!

    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
//        var updateTimer = Timer.scheduledTimer(withTimeInterval: 2, target: self, selector: #selector(self.updatePrize), repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func update(){
        let timeTuple = getTimeIntervalTuple(interval: hourSinceThen())
        dayLabel.text = "\(timeTuple.day)"
        hourLabel.text = "\(timeTuple.hour)"
        minuteLabel.text = "\(timeTuple.minute)"
        secondLabel.text = "\(timeTuple.second)"
    }
    
    func updatePrize(){
//        prizeLabel.text = ""
    }
    
    func hourSinceThen() -> TimeInterval{
        let now = Date()
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = calendar.components(([.year, .month, .day, .weekday, .hour, .minute, .second, .calendar]), from: now )
        var expected = flattenTheDate(dateComponent: components)
        switch components.weekday! {
        case 1:
            if (components.hour! >= 18){
                expected.day! += 3
            }
        case 2:
            expected.day! += 2
        case 3:
            expected.day! += 1
        case 4:
            if (components.hour! >= 18){
                expected.day! += 2
            }
        case 5:
            if (components.hour! >= 18){
                expected.day! += 1
            }
        case 6:
            expected.day! += 2
        case 7:
            expected.day! += 1
        default:
            print("add later")
        }
        return (expected.date?.timeIntervalSince(components.date!))!
    }
    
    func flattenTheDate(dateComponent: DateComponents) -> DateComponents {
        var tempDateComponent = dateComponent
        tempDateComponent.hour = 18;
        tempDateComponent.minute = 0
        tempDateComponent.second = 0
        return tempDateComponent
    }
    
    func getTimeIntervalTuple(interval: TimeInterval) -> (day: Int, hour: Int, minute: Int, second: Int) {
        let total = Int(interval)
        let tempSecond = total % 60
        let tempMinute = (total / 60) % 60
        let tempHour = (total / 60 / 60) % 24
        let tempDay = total / 60 / 60 / 24
        return (tempDay, tempHour, tempMinute, tempSecond)
    }
    
}
