//
//  HistoryCell.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var lotteryNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var lottery: Lottery! {
        didSet {
            hourLabel.text = lottery.timeCreate
            lotteryNumberLabel.text = lottery.lotteryNumber
            dateLabel.text = lottery.timeCreate
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
