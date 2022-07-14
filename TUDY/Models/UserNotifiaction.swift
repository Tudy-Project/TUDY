//
//  UserNotifiaction.swift
//  TUDY
//
//  Created by neuli on 2022/07/13.
//

import Foundation

struct UserNotification: Codable {
    var userID: String
    var nickname: String
    var profileImageURL: String
    
    init (
        userID: String = "",
        nickname: String = "",
        profileImageURL: String = ""
    ) {
        self.userID = userID
        self.nickname = nickname
        self.profileImageURL = profileImageURL
    }
    
    init(dict: [String : Any]) {
        self.userID = dict["userID"] as? String ?? ""
        self.nickname = dict["nickname"] as? String ?? ""
        self.profileImageURL = dict["profileImageURL"] as? String ?? ""
    }
}
