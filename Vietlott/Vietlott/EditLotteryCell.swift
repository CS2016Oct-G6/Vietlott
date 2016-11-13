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
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var cellView: UIView!
    
    weak var delegate: EditLotteryCellDelegate?
    
    var lottery: String! {
        didSet {
            lotteryNumberLabel.text = lottery.toLotteryString()
            // get system time
            let date = Date()
            dateLabel.text = date.toString()
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
