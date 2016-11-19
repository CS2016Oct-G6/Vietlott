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
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
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
        if let avatar = Constance.userInfo.avatar {
            let imageRequest = URLRequest(
                url: URL(string: avatar)!,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            avatarImageView.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        self.avatarImageView.alpha = 0.0
                        self.avatarImageView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.avatarImageView.alpha = 1.0
                        })
                    } else {
                        //print("Image was cached so just update the image")
                        self.avatarImageView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
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
