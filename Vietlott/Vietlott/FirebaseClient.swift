//
//  FirebaseClient.swift
//  testFirebase
//
//  Created by Liem Ly Quan on 11/16/16.
//  Copyright © 2016 liemly. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseClient {
    static let sharedInstance = FirebaseClient()
    var ref: FIRDatabaseReference!
    
    init() {
        ref = FIRDatabase.database().reference()
    }
    
    
    func login() {
        
    }
    
    func postUserEntry(entries: [Lottery]){
        for entry in entries {
            guard
                let numbers = entry.lotteryNumber,
                let date = entry.timeCreate,
                let userID = FIRAuth.auth()?.currentUser?.uid
            else {
                break
            }
            self.ref.child("users/\(userID)/history").childByAutoId().setValue([
                "numbers": numbers,
                "date": date
            ])
        }
        

    }
    
    func getWinningHistory(completion: @escaping ([Lottery]?, Error?) -> ()){
        ref.child("winning/history").observeSingleEvent(of: .value, with: { (response) in
            // Get user value
            
            guard let result = response.value as? NSDictionary else {
                return
            }
            
            
            var entries:[Lottery] = []
            for (key, val) in result {
                guard
                    let numbers = val as? String,
                    let date = key as? String
                    else {
                        return
                }
                let entry = Lottery(lottery: numbers, time: date)
                entries.append(entry)
            }
            
            
            completion(entries, nil)
            
            // ...
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func getUserHistory(completion: @escaping ([Lottery]?, Error?) -> ()){
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            return
        }

        ref.child("users/\(userID)/history").observeSingleEvent(of: .value, with: { (response) in
            // Get user value
            
            guard let result = response.value as? NSDictionary else {
                return
            }
            
            
            var entries:[Lottery] = []
            for (key, val) in result {
                guard
                    let val = val as? NSDictionary,
                    let numbers = val["numbers"] as? String,
                    let date = val["date"] as? String
                    else {
                        return
                }
                let entry = Lottery(lottery: numbers, time: date)
                entries.append(entry)
            }
            
            
            completion(entries, nil)
            
            // ...
        }) { (error) in
            completion(nil, error)
        }
        
    }
    
}
