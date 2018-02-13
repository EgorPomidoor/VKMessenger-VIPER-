//
//  DetailChatModel.swift
//  VKMessenger
//
//  Created by Егор on 11.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class DetailChatModel {
    
    var id: Int64
    var userID: Int64
    var fromID: Int64
    var body: String
    var date: Int64
    var out: Int64
    var readState: Int64
    
    init(id: Int64, userID: Int64, fromID: Int64, body: String, date: Int64, out: Int64, readState: Int64) {
        self.id = id
        self.userID = userID
        self.fromID = fromID
        self.body = body
        self.date = date
        self.out = out
        self.readState = readState
    }
    
    
}
