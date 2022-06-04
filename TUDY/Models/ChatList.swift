//
//  ChatList.swift
//  TUDY
//
//  Created by neuli on 2022/06/03.
//

import Foundation

struct ChatList: Hashable {
    var chatState: ChatState 
    var chatNotification: Bool = true
    var bookMark: Bool = false
    var profileImageURL: String = ""
    var name: String = ""
    var latestMessage: String = ""
    var latestMessageDate: String = ""
}
