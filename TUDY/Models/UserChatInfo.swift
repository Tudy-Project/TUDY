//
//  UserChatInfo.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

struct UserChatInfo: Codable {
    var chatInfoID: String
    var chatNotification: Bool = true
    var bookMark: Bool = false
    var dontReadCount: Int = 0
    
    init(chatInfoID: String,
         chatNotification: Bool = true,
         bookMark: Bool = false) {
        self.chatInfoID = chatInfoID
        self.chatNotification = chatNotification
        self.bookMark = bookMark
    }
    
    init(dict: [String : Any]) {
        self.chatInfoID = dict["chatInfoID"] as? String ?? ""
        self.chatNotification = dict["chatNotification"] as? Bool ?? true
        self.bookMark = dict["bookMark"] as? Bool ?? false
        self.dontReadCount = dict["dontReadCount"] as? Int ?? 0
    }
}
