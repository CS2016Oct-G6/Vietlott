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
    
    var animator = CircleAnimator()
    
    let duration = 0.3
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerChartView: UIView!
    
    @IBOutlet weak var coverImageView: CustomImageView!
    @IBOutlet weak var avatarImageView: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var manualButton: UIButton!
    
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
    
    @IBAction func showRecommendView(_ sender: Any) {
        // present recommend view
        let storyboart = UIStoryboard(name: "Main", bundle: nil)
        let recommendVC = storyboart.instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
        
        // open view
        recommendVC.transitioningDelegate = self.animator
        recommendVC.modalPresentationStyle = .custom
        self.present(recommendVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination
        
        // set point to draw
        Constance.pointToDraw = (Double(manualButton.center.x), Double(manualButton.center.y))
        
        // 1. set delegate and custom presentationModelStyle
        desVC.transitioningDelegate = animator
        desVC.modalPresentationStyle = .custom
        desVC.view.backgroundColor = UIColor.clear
    }
    
    @IBAction func changeViewHistoryLottery(_ sender: UIButton) {
        if isTableView {
            // change image button to list
            sender.setImage(UIImage(named: "List"), for: .normal)
            
            containerChartView.alpha = 0.0
            containerChartView.isHidden = false
            
            UIView.animate(withDuration: duration, animations: {
                self.tableView.center.x += 50
            }, completion: { (animation) in
                self.tableView.center.x -= 50
            })
            
            UIView.animate(withDuration: duration, animations: {
                self.containerChartView.alpha = 1
            }, completion: { (animation) in
                
            })
            
            // change state
            isTableView = false
        } else {
            // change image button to chart
            sender.setImage(UIImage(named: "Combo Chart"), for: .normal)
            
            UIView.animate(withDuration: duration, animations: {
                self.containerChartView.center.x += 50
            }, completion: { (animation) in
                self.containerChartView.center.x -= 50
            })
            
            UIView.animate(withDuration: duration, animations: {
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
