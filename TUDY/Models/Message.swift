//
//  Message.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

struct Message: Codable {
    let messageID: String
    let content: String
    let sender: User
    let createdDate: String
    
    init(messageID: String,
         content: String,
         sender: User,
         createdDate: String) {
        self.messageID = messageID
        self.content = content
        self.sender = sender
        self.createdDate = createdDate
    }
    
    init(content: String,
         sender: User,
         createdDate: String) {
        self.messageID = UUID().uuidString
        self.content = content
        self.sender = sender
        self.createdDate = createdDate
    }
    
    init(dict: [String : Any]) {
        self.messageID = dict["messageID"] as? String ?? ""
        self.content = dict["content"] as? String ?? ""
        self.sender = dict["sender"] as? User ?? User()
        self.createdDate = dict["createdDate"] as? String ?? ""
    }
}
