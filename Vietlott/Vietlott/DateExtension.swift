//
//  DateExtension.swift
//  Camera&Number2
//
//  Created by CongTruong on 11/12/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm dd/MM/yyyy"
        return dateFormat.string(from: self)
    }
}
