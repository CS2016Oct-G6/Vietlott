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
        let lottery = ["224677984409", "054677912489", "224677984423", "224677986511", "224677774443",
                       "224677234409", "221277984489", "224676584423", "224674584411", "224677932443",
                       "224644984409", "224677984489", "224677984423", "224675674411", "224677674443",
                       "224677984408"]
        var lotteryArray = [Lottery]()
        for i in 0..<16 {
            lotteryArray.append(Lottery(lottery: lottery[i], time: "11:20 20/11/2016"))
        }
        
        Constance.lotteryArrayHistory = lotteryArray
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
