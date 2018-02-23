//
//  VKMConst.swift
//  VKMessenger
//
//  Created by Егор on 18.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class VKMConst {
    
    class APIService {
        static let kBaseURL = "https://api.vk.com/method/"
    }
    
    class URLMethods {
        static let kMessage = "messages.getDialogs"
        static let kUser = "users.get"
        static let kDetailChat = "messages.getHistory"
        static let kSendMes = "messages.send"
    }
    
    class URLArguments {
        static let kCount = "count"
        static let kIds = "user_ids"
        static let kFields = "fields"
        static let kOffset = "offset"
        static let kUserId = "user_id"
        static let kPeerId = "peer_id"
        static let kRandomId = "random_id"
    }
    
}
