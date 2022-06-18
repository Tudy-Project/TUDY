//
//  Message.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

struct Message: Codable {
    var content: String
    var imageURL: String
    var sender: User
    var createdDate: String
    
    init(content: String,
         imageURL: String,
         sender: User,
         createdDate: String) {
        self.content = content
        self.imageURL = imageURL
        self.sender = sender
        self.createdDate = createdDate
    }
    
    init(dict: [String : Any]) {
        self.content = dict["content"] as? String ?? ""
        self.imageURL = dict["imageURL"] as? String ?? ""
        let senderDict = dict["sender"] as? [String: Any] ?? [:]
        self.sender = User(dict: senderDict)
        self.createdDate = dict["createdDate"] as? String ?? ""
    }
}
