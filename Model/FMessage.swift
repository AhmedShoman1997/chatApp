//
//  FMessage.swift
//  MyChatTest
//
//  Created by Ahmed Shoman on 3/15/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import Foundation

class Messages{

    var message: String
    var senderId: String
    var senderName: String
    var date: Date
    var type: String
    var messageType: String
    var messageId: String
    var picture: String
    
    init(message: String, senderId: String, senderName: String, date: Date, messageType: String, type: String, messageId: String, picture: String) {
        
        self.message = message
        self.senderId = senderId
        self.senderName = senderName
        self.date = date
        self.type = type
        self.messageId = messageId
        self.picture = picture
        self.messageType = messageType
    }
    
    
    
    init(_dictionary: NSDictionary) {
        
        if let created = _dictionary[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        
        if let msg = _dictionary[kMESSAGE] {
            message = msg as! String
        } else {
            message = ""
        }

        if let sender = _dictionary[kSENDERID] {
            senderId = sender as! String
        } else {
            senderId = ""
        }

        if let name = _dictionary[kSENDERNAME] {
            senderName = name as! String
        } else {
            senderName = ""
        }
        
        if let Type = _dictionary[kTYPE] {
            type = Type as! String
        } else {
            type = ""
        }
        
        if let mType = _dictionary[kMESSAGETYPE] {
            messageType = mType as! String
        } else {
            messageType = ""
        }
        
        if let id = _dictionary[kMESSAGEID] {
            messageId = id as! String
        } else {
            messageId = ""
        }
        
        if let pic = _dictionary[kPICTURE] {
            picture = pic as! String
        } else {
            picture = ""
        }

    }
    
}


