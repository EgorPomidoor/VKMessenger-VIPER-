//
//  LongPollService.swift
//  VKMessenger
//
//  Created by Егор on 22.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class LongPollService {
    
    class func startLongPoll (key: String, server: String, ts: String) {
        
        API_WRAPPER.startLongPoll(key: key, server: server, ts: ts, success: { (response) in
            let newTs = response["ts"].stringValue
            let updates = response["updates"].arrayValue
            
            if updates.count != 0 {
                for update in updates {
                    if update[0] == 4 {
                        let context = CoreDataManager.sharedInstance.getBackgroundContext()
                        let set = NSMutableSet()
                        
                        let messageId = update[1].int64Value
                        let mask = decodeMask(i: update[2].intValue)
                        let userID = update[3].intValue > 2000000000 ? update[6]["from"].int64Value : update[3].int64Value
                        let timestamp = update[4].int64Value
                        let text = update[5].stringValue
                        let readState = mask[0] == 1 ? 0 : 1
                        let out = mask[1] == 1 ? 1 : 0
                        let fromID = update[3].intValue > 2000000000 ? update[6]["from"].int64Value :  out == 1 ? Int64(VKMAuthService.sharedInstance.getMyID()) : userID
                        
                        let peerID = update[3].intValue > 2000000000 ? Int64(update[3].intValue - 2000000000) : update[3].int64Value
                        
                        CoreDataDetailChatFabric.setDetailChat(id: messageId, userID: userID, fromID: fromID!, body: text, date: timestamp, out: Int64(out), readState: Int64(readState), context: context)
                        let message = CoreDataDetailChatFabric.getDetailChat(id: messageId, context: context)
                        set.add(message)
                        CoreDataChatFabric.addMessagesToChat(chatID: peerID, messagesSet: set, context: context)
                       _ = try? context.save()
                    }
                }
            }
            startLongPoll(key: key, server: server, ts: newTs)
            
        }, failure: {(error) in
            print(error)
        })
    }
    
    
    private class func decodeMask (value: Int) -> [String] {
        let binaryString = String(value,radix: 2)
        let array  = binaryString.map({String($0)})
        return array
    }
    
    private class func decodeMask(i: Int)-> [Int] {
        let array = [1,2,4,8,16,32,64,128,256,512]
        var binary = [Int]()
        for b in array {
            if i&b == 0 {
                binary.append(0)
            } else {
                binary.append(1)
            }
        }
        return binary
    }
}


