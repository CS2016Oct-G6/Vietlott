//
//  DialViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class DialViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    
    let colors = [UIColor.red, UIColor.blue, UIColor.cyan, UIColor.green, UIColor.red, UIColor.orange, UIColor.yellow, UIColor.red]

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
    
    override func viewWillAppear(_ animated: Bool) {
        let animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityBehavior = UIGravityBehavior()
        animator.addBehavior(gravityBehavior)
        self.gravityBehavior = gravityBehavior
        
        let collisionBehavior = UICollisionBehavior()
        // add boundary below
        collisionBehavior.addBoundary(withIdentifier: "below" as NSCopying, from: CGPoint(x: 0, y: self.view.frame.size.height), to: CGPoint(x: self.view.frame.size.width, y: self.view.frame.size.height))
        collisionBehavior.collisionDelegate = self
        animator.addBehavior(collisionBehavior)
        self.collisionBehavior = collisionBehavior
        
        self.animator = animator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let loteryWin = Constance.lotteryWin.toLotteryString()
        lotteryWinArray = loteryWin.characters.split{$0 == " "}.map(String.init)
        lotteryOfUserArray = Constance.filteredArrayHistory
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
                
                // if have lottery win
                if self.lotteryOfUserArray.count > 0 {
                    Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(DialViewController.createRandomSnow), userInfo: nil, repeats: true)
                }
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

extension DialViewController: UICollisionBehaviorDelegate{
    func createRandomSnow() {
        let newSnow = UIView(frame: CGRect(x: Int(arc4random_uniform(UInt32(self.view.frame.size.width))), y: 0, width: 5, height: 5))
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        newSnow.backgroundColor = color
        self.view.addSubview(newSnow)
        
        
        gravityBehavior.addItem(newSnow)
        collisionBehavior.addItem(newSnow)
    }
    
    func meltSnow(snowView: UIView) {
        gravityBehavior.removeItem(snowView)
        collisionBehavior.removeItem(snowView)
        
        snowView.removeFromSuperview()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        // You have to convert the identifier to a string
        let boundary = identifier as? String
        
        // The view that collided with the boundary has to be converted to a view
        let view = item as? UIView
        
        if boundary == "shelter" {
            // Detected collision with a boundary called "shelf"
        } else if boundary == "below" {
            run(after: 0.5, closure: {
                self.meltSnow(snowView: view!)
            })
        }
    }
}
