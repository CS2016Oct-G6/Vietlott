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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
