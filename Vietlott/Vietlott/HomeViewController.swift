//
//  HomeViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
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
                        let date = subVal["date"] as? String
                    else {
                        return
                    }
                    let lottery = Lottery(lottery: numbers, time: date)
                    lotteryList.append(lottery)
                }
            }
            Constance.lotteryArrayHistory = lotteryList
            
        })
        
    }
    
    @IBAction func showDialView(_ sender: UIButton) {
        let storyboart = UIStoryboard(name: "Main", bundle: nil)
        let dialVC = storyboart.instantiateViewController(withIdentifier: "dialViewController") as! DialViewController
        
        // open view
        dialVC.modalPresentationStyle = .overFullScreen;
        dialVC.view.backgroundColor = UIColor.clear
        self.present(dialVC, animated: true, completion: nil)
    }

    
}
