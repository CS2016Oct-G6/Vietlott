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
    
    func subString(from: Int, to: Int) -> String {
        if from > 0 && to < self.characters.count {
            let index1 = self.index(self.startIndex, offsetBy: from)
            let index2 = self.index(self.startIndex, offsetBy: to)
            
            var substring = self.substring(to: index2)
            substring = substring.substring(from: index1)
            
            return substring
        }
        
        return ""
    }
}
