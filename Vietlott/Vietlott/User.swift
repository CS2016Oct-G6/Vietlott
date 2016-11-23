//
//  User.swift
//  Vietlott
//
//  Created by CongTruong on 11/18/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class User {
    var name: String?
    var email: String?
    var avatar: String?
    
    init(name: String?, email: String?, avatar: String?) {
        self.name = name
        self.email = email
        self.avatar = avatar
    }
}
