//
//  DialCell.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class DialCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var lotteryNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var lottery: Lottery! {
        didSet {
            lotteryNumberLabel.text = lottery.lotteryNumber!.toLotteryString()
            var myStringArr = lottery.timeCreate!.components(separatedBy: " ")
            dateLabel.text = myStringArr[1]
            hourLabel.text = myStringArr[0]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
