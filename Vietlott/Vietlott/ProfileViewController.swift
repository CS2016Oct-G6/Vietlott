//
//  ProfileViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/16/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var lotteryArray = [Lottery]()
    
    override func viewWillAppear(_ animated: Bool) {
        for _ in 1...10 {
            lotteryArray.append(Lottery(lottery: "12 34 56 78 90 19", time: "20/11/2016 11:20"))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lotteryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        cell.lottery = lotteryArray[indexPath.row]
        cell.hourLabel.text = "11:20 pm"
        cell.dateLabel.text = "20/11/2011"
        
        cell.selectionStyle = .none
        
        return cell
    }
}
