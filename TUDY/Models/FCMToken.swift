//
//  UserToken.swift
//  TUDY
//
//  Created by neuli on 2022/07/11.
//

import Foundation

struct FCMToken: Codable {
    var userID: String
    var fcmToken: String
    
    init(userID: String, fcmToken: String) {
        self.userID = userID
        self.fcmToken = fcmToken
    }
    
    init(dict: [String : Any]) {
        self.userID = dict["userID"] as? String ?? ""
        self.fcmToken = dict["fcmToken"] as? String ?? ""
    }
}
