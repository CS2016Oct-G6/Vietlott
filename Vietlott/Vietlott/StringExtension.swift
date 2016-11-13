//
//  StringExtension.swift
//  Camera&Number2
//
//  Created by CongTruong on 11/12/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import Foundation

extension String {
    mutating func toLotteryString() -> String {
        var newString = self
        let indexArray = [2, 5, 8, 11, 14]
        
        for idx in indexArray {
            newString = String(newString.characters.prefix(idx)) +
                        " " +
                        String(newString.characters.suffix(newString.characters.count - idx))
        }
        
        return newString
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
