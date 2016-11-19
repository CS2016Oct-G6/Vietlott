//
//  DialViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class DialViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var sixLabel: UILabel!
    
    @IBOutlet weak var startDualButton: UIButton!
    
    let numberLotteryArray = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
                              "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
                              "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
                              "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
                              "40", "41", "42", "43", "44", "45"]
    var timeLeftArray = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    
    var timer = [Timer]()
    var isCancel = false
    
    var lotteryWinArray = [String]()
    var lotteryOfUserArray = [Lottery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        lotteryWinArray = Constance.lotteryWin.characters.split{$0 == " "}.map(String.init)
        lotteryOfUserArray = Constance.lotteryArrayHistory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startDual(_ sender: UIButton) {
        if isCancel {
            for i in 0...5 {
                timer[i].invalidate()
            }
            
            self.dismiss(animated: true, completion: nil)
        } else {
            createDualThread()
            startDualButton.setTitle("Cancel", for: .normal)
            isCancel = true
        }
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
                self.oneLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                self.oneLabel.text = self.lotteryWinArray[labelIndex]
            })
        case 1:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.twoLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                self.twoLabel.text = self.lotteryWinArray[labelIndex]
            })
        case 2:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.threeLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                self.threeLabel.text = self.lotteryWinArray[labelIndex]
            })
        case 3:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.fourLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                self.fourLabel.text = self.lotteryWinArray[labelIndex]
            })
        case 4:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: {
                self.fiveLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: {
                self.fiveLabel.text = self.lotteryWinArray[labelIndex]
            })
        case 5:
            processTimerForNumber(labelIndex: labelIndex, handleChangeLabel: { 
                self.sixLabel.text = self.numberLotteryArray[Int(arc4random_uniform(45))]
            }, handleSetLabel: { 
                self.sixLabel.text = self.lotteryWinArray[labelIndex]
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
            // delete cell if not valid
            self.deleteCell(labelIndex: labelIndex)
            // reload table view
            self.tableView.reloadData()
        })
        
        timer.append(t)
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func deleteCell(labelIndex: Int) {
        var index =  lotteryOfUserArray.count - 1
        while index >= 0 {
            let indexSubString = 2 * (labelIndex + 1)
            
            if lotteryOfUserArray[index].lotteryNumber!.subString(from: indexSubString - 2, to: indexSubString) != lotteryWinArray[labelIndex] {
                lotteryOfUserArray.remove(at: index)
            }
            
            index -= 1
        }
    }
}

extension DialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lotteryOfUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialCell", for: indexPath) as! DialCell
        
        cell.lottery = lotteryOfUserArray[indexPath.row]
        
        return cell
    }
}
