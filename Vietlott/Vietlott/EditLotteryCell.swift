//
//  EditLotteryCell.swift
//  Camera&Number2
//
//  Created by CongTruong on 11/12/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

@objc protocol EditLotteryCellDelegate {
    @objc optional func edit(cell: EditLotteryCell)
}

class EditLotteryCell: UITableViewCell {

    @IBOutlet weak var lotteryNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var cellView: UIView!
    
    weak var delegate: EditLotteryCellDelegate?
    
    var lottery: Lottery! {
        didSet {
            lotteryNumberLabel.text = lottery.lotteryNumber!.toLotteryString()
            var myStringArr = lottery.timeCreate!.components(separatedBy: " ")
            dateLabel.text = myStringArr[1]
            timeLabel.text = myStringArr[0]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editLottery(_ sender: UIButton) {
        delegate?.edit!(cell: self)
    }
}
