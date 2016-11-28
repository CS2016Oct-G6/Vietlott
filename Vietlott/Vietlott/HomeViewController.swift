//
//  HomeViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import Kanna

class HomeViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        webView.loadRequest(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "htmlCode", ofType: "html")!) as URL) as URLRequest)
        displayURL()
    }
    
    func getData() {
        FirebaseClient.sharedInstance.getUserHistory(completion: { (lotteryHistory, error) in
            guard
                let lotteryHistory = lotteryHistory
            else {
                return
            }
            var lotteryList:[Lottery] = []
            for (key, val) in lotteryHistory {
                guard
                    let yearMonthString = key as? String,
                    let month = Int(yearMonthString.subString(from: 5, to: 7)),
                    let monthlySold = val as? NSDictionary
                else {
                    return
                }
                
                
                Constance.unitsSold[month-1] = Double(monthlySold.allKeys.count)
                for (subKey, subVal) in monthlySold {
                    guard
                        let subVal = subVal as? NSDictionary,
                        let numbers = subVal["numbers"] as? String,
                        let dateString = subVal["date"] as? String
                    else {
                        return
                    }
                    let lottery = Lottery(lottery: numbers, time: dateString)
//                    if dateString.toDate().timeIntervalSince(<#T##date: Date##Date#>)
                    lotteryList.append(lottery)
                }
            }
            Constance.lotteryArrayHistory = lotteryList
            
        })
        
    }
    
    func displayURL() {
        var result:String
        
        if let doc = Kanna.HTML(url: (NSURL(string: "http://vietlott.vn")!) as URL, encoding: String.Encoding.utf8) {
            print("body.... \(doc.title!)");
            
            for show in doc.css("ul[class^='result-number']") {
                result = show.text!
                
                let formattedString = result.replacingOccurrences(of: "\r\n", with: "")
                
                let trimmedString = formattedString.trimmingCharacters(in: .whitespaces)
                
                let str = trimmedString.removeExcessiveSpaces
                
                
                let first = str[0] // First
                let second = str[1] // First
                
                print(first)
                print(second)
                print(str)
                
            }
            
            var winningMoney = "";
            
            for h2 in doc.css("h2") {
                
                let result = h2.text!
                
                let formattedString = result.replacingOccurrences(of: "\r\n", with: "")
                
                let trimmedString = formattedString.trimmingCharacters(in: .whitespaces)
                
                if(trimmedString != ""){
                    print("wingng money.... \(trimmedString)")
                }
                
                winningMoney = trimmedString
                
            }
            UserDefaults(suiteName: "group.vietlott")!.set(winningMoney, forKey: "currentWinning")
            print(UserDefaults(suiteName: "group.vietlott")!.string(forKey: "currentWinning")!)

        }
    }
    
    
    @IBAction func showDialView(_ sender: UIButton) {
        let storyboart = UIStoryboard(name: "Main", bundle: nil)
        let dialVC = storyboart.instantiateViewController(withIdentifier: "dialViewController") as! DialViewController
        
        // open view
        dialVC.modalPresentationStyle = .overFullScreen;
        dialVC.view.backgroundColor = UIColor.clear
        self.present(dialVC, animated: true, completion: nil)
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
    
    
}
