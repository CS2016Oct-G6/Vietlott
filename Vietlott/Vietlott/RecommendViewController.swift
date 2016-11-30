//
//  RecommendViewController.swift
//  randomLottery
//
//  Created by CongTruong on 11/28/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import ARSLineProgress

class RecommendViewController: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirstLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    
    let numberLotteryArray = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
                              "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
                              "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
                              "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
                              "40", "41", "42", "43", "44", "45"]
    var timeLeftArray = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    
    var timer = [Timer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveLottery(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {() -> Void in
            self.successImageView.alpha = 1
        }, completion: {(Bool) -> Void in
            self.successImageView.alpha = 0
        })
        
        var text = firstLabel.text!
        text = text + secondLabel.text!
        text = text + thirstLabel.text!
        text = text + fourthLabel.text!
        text = text + fifthLabel.text!
        text = text + sixthLabel.text!
            
        FirebaseClient.sharedInstance.postUserEntry(
            entries: [
                Lottery(lottery: text, time: Date().toString())
            ])
        let newLottery = Lottery(lottery: text, time: Date().toString())
        Constance.lotteryArrayHistory = [newLottery] + Constance.lotteryArrayHistory
        Constance.filteredArrayHistory = [newLottery] + Constance.filteredArrayHistory
        
    }
    
    @IBAction func randomNextLottery(_ sender: Any) {
        createDualThread()
    }
    
    func createDualThread() {
        for i in 0...5 {
            createTimerFor(labelIndex: i)
        }
    }
    
    func createTimerFor(labelIndex: Int) {
        switch labelIndex {
        case 0:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.firstLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                //self.fifthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            })
        case 1:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.secondLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                //self.secondLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            })
        case 2:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.thirstLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                //self.thirstLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            })
        case 3:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.fourthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                //self.fourthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            })
        case 4:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.fifthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                //self.fifthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            })
        case 5:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.sixthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                //self.sixthLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            })
        default:
            return
        }
    }
    
    func processTimerForNumber(labelIndex: Int, handleChangeLabel: @escaping () -> (), handleSetLabel: @escaping () -> ()) {
        // create timer
        let t = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {(Timer) -> Void in
            handleChangeLabel()
        })
        // off timer after time left
        run(after: timeLeftArray[labelIndex], closure: {
            // stop timer
            t.invalidate()
            // set lottery number for label
            handleSetLabel()
        })
        
        timer.append(t)
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
}
