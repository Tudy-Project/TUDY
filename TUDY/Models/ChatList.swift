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
    var chatTitle: String = "" // 개인챗 default: 상대방 이름, 그룹챗 default: 미정
    var profileImageURL: String = ""
    var projectMasterID = ""
    var participantIDs: [String] = []
    var latestMessage: String = ""
    var latestMessageDate: String = ""
}
