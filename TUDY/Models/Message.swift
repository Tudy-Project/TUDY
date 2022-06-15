//
//  Message.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

struct Message: Codable {
    let content: String
    let sender: User
    let createdDate: String
    
    init(content: String,
         sender: User,
         createdDate: String) {
        self.content = content
        self.sender = sender
        self.createdDate = createdDate
    }
    
    init(dict: [String : Any]) {
        self.content = dict["content"] as? String ?? ""
        self.sender = dict["sender"] as? User ?? User()
        self.createdDate = dict["createdDate"] as? String ?? ""
    }
}
