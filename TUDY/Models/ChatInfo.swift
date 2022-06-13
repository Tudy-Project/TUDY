//
//  ChatList.swift
//  TUDY
//
//  Created by neuli on 2022/06/03.
//

import Foundation

struct ChatInfo: Hashable, Codable {
    var chatInfoID: String = UUID().uuidString
    var chatState: ChatState 
    var chatNotification: Bool = true
    var bookMark: Bool = false
    var chatTitle: String = "" // 개인챗 default: 상대방 이름, 그룹챗 default: 미정
    var profileImageURL: String = ""
    var projectMasterID = ""
    var participantIDs: [String] = []
    var latestMessage: String = ""
    var latestMessageDate: String = ""
    
    init(chatState: ChatState,
         chatNotification: Bool = true,
         bookMark: Bool = false,
         chatTitle: String = "",
         profileImageURL: String = "",
         projectMasterID: String = "",
         participantIDs: [String] = [],
         latestMessage: String = "",
         latestMessageDate: String = "") {
        self.chatState = chatState
        self.chatNotification = chatNotification
        self.bookMark = bookMark
        self.chatTitle = chatTitle
        self.profileImageURL = profileImageURL
        self.projectMasterID = projectMasterID
        self.participantIDs = participantIDs
        self.latestMessage = latestMessage
        self.latestMessageDate = latestMessageDate
    }
    
    init(dict: [String : Any]) {
        self.chatInfoID = dict["chatInfoID"] as? String ?? ""
        self.chatState = dict["chatState"] as? ChatState ?? .personalChat
        self.chatNotification = dict["chatNotification"] as? Bool ?? true
        self.bookMark = dict["bookMark"] as? Bool ?? false
        self.chatTitle = dict["chatTitle"] as? String ?? ""
        self.profileImageURL = dict["profileImageURL"] as? String ?? ""
        self.projectMasterID = dict["projectMasterID"] as? String ?? ""
        self.participantIDs = dict["participantIDs"] as? [String] ?? []
        self.latestMessage = dict["latestMessage"] as? String ?? ""
        self.latestMessageDate = dict["latestMessageDate"] as? String ?? ""
    }
}
