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
    var chatTitle: String = "" // 개인챗 안씀, 그룹챗 default: 미정
    var projectMasterID = ""
    var participantIDs: [String] = []
    var latestMessage: String = ""
    var latestMessageDate: String = ""
    
    init(chatState: ChatState,
         chatTitle: String = "",
         projectMasterID: String = "",
         participantIDs: [String] = [],
         latestMessage: String = "",
         latestMessageDate: String = "") {
        self.chatState = chatState
        self.chatTitle = chatTitle
        self.projectMasterID = projectMasterID
        self.participantIDs = participantIDs
        self.latestMessage = latestMessage
        self.latestMessageDate = latestMessageDate
    }
    
    init(dict: [String : Any]) {
        self.chatInfoID = dict["chatInfoID"] as? String ?? ""
        let chat = dict["chatState"] as? String ?? "personalChat"
        self.chatState = chat == "groupChat" ? .groupChat : .personalChat
        self.chatTitle = dict["chatTitle"] as? String ?? ""
        self.projectMasterID = dict["projectMasterID"] as? String ?? ""
        self.participantIDs = dict["participantIDs"] as? [String] ?? []
        self.latestMessage = dict["latestMessage"] as? String ?? ""
        self.latestMessageDate = dict["latestMessageDate"] as? String ?? ""
    }
}
