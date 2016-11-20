//
//  ProfileViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/16/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerChartView: UIView!
    
    @IBOutlet weak var coverImageView: CustomImageView!
    @IBOutlet weak var avatarImageView: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var lotteryArray = [Lottery]()
    var isTableView = true
    
    override func viewWillAppear(_ animated: Bool) {
        if let name = Constance.userInfo.name {
            nameLabel.text = name
        }
        if let email = Constance.userInfo.email {
            emailLabel.text = email
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let urlCoverImage = URL(string: "http://www.tipinasia.info/wp-content/uploads/2015/03/s%C3%A9jour-au-Vietnam.jpg")
        coverImageView.setImageWith(urlCoverImage!)
        
        
        if let avatar = Constance.userInfo.avatar {
            let url = URL(string: avatar)
            avatarImageView.setImageWith(url!)
        } else {
            let url = URL(string: "http://img3.tamtay.vn/files/photo2/2015/5/10/21/16218227/554f6d6d_125d8919__mg_1450.jpg")
            avatarImageView.setImageWith(url!)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        lotteryArray = Constance.lotteryArrayHistory
    }
    
    @IBAction func showInputView(_ sender: Any) {
        let storyboart = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboart.instantiateViewController(withIdentifier: "editlotteryViewController") as! EditLotteryViewController
        
        // open view
        editVC.modalPresentationStyle = .overFullScreen;
        editVC.view.backgroundColor = UIColor.clear
        self.present(editVC, animated: true, completion: nil)
    }
    
    @IBAction func changeViewHistoryLottery(_ sender: UIButton) {
        if isTableView {
            // change image button to list
            sender.setImage(UIImage(named: "List"), for: .normal)
            
            containerChartView.alpha = 0.0
            containerChartView.isHidden = false
            
            UIView.animate(withDuration: 1, animations: { 
                self.tableView.center.x += 50
            }, completion: { (animation) in
                self.tableView.center.x -= 50
            })
            
            UIView.animate(withDuration: 1, animations: { 
                self.containerChartView.alpha = 1
            }, completion: { (animation) in
                
            })
            
            // change state
            isTableView = false
        } else {
            // change image button to chart
            sender.setImage(UIImage(named: "Combo Chart"), for: .normal)
            
            UIView.animate(withDuration: 1, animations: {
                self.containerChartView.center.x += 50
            }, completion: { (animation) in
                self.containerChartView.center.x -= 50
            })
            
            UIView.animate(withDuration: 1, animations: {
                self.containerChartView.alpha = 0
            }, completion: { (animation) in
                self.containerChartView.isHidden = true
            })
            
            // change state
            isTableView = true
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lotteryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        cell.lottery = lotteryArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}
