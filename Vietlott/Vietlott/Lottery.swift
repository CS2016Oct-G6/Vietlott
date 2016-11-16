//
//  Lottery.swift
//  Vietlott
//
//  Created by CongTruong on 11/17/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class Lottery {
    var lotteryNumber: String?
    var timeCreate: String?
    
    init(lottery: String, time: String) {
        self.lotteryNumber = lottery
        self.timeCreate = time
    }
}
