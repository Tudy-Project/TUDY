//
//  User.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation

struct User: Codable {
    var userId: Int
    var signUpDate: Int
    var nickname: String
    var profileImage: String
    var interestedJob: [String] // job 구조체
    var subways: String // 지하철 구조체
    var likeProjectId: String?
    var personalChat: [String]?
    var groupChat: [String]?
    
    init (
        userId: Int = 0,
        signUpDate: Int = 0,
        nickname: String = "",
        profileImage: String = "",
        interestedJob: [String] = [],
        subways: String = "",
        likeProjectId: String = "",
        personalChat: [String] = [],
        groupChat: [String] = []
    ) {
        self.userId = userId
        self.signUpDate = signUpDate
        self.nickname = nickname
        self.profileImage = profileImage
        self.interestedJob = interestedJob
        self.subways = subways
        self.likeProjectId = likeProjectId
        self.personalChat = personalChat
        self.groupChat = groupChat
    }
}

extension Encodable {
    /// Object to Dictionary
    /// cf) Dictionary to Object: JSONDecoder().decode(Object.self, from: dictionary)
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictinoary
    }
}
