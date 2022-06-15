//
//  User.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation

struct User: Codable {
    var userID: String
    var signUpDate: String
    var nickname: String
    var profileImageURL: String
    var interestedJob: String
    var interestedDetailJobs: [String]
    var subwayStation: String
    var subwayLines: [String]
    var likeProjectIDs: [String]
//    var personalChatInfos: [UserChatInfo]
//    var groupChatInfos: [UserChatInfo]
    
    init (
        userID: String = "",
        signUpDate: String = "",
        nickname: String = "",
        profileImageURL: String = "",
        interestedJob: String = "",
        interestedDetailJobs: [String] = [],
        subwayStation: String = "",
        subwayLines: [String] = [],
        likeProjectIDs: [String] = []
//        personalChatInfos: [UserChatInfo] = [],
//        groupChatInfos: [UserChatInfo] = []
    ) {
        self.userID = userID
        self.signUpDate = signUpDate
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.interestedJob = interestedJob
        self.interestedDetailJobs = interestedDetailJobs
        self.subwayStation = subwayStation
        self.subwayLines = subwayLines
        self.likeProjectIDs = likeProjectIDs
//        self.personalChatInfos = personalChatInfos
//        self.groupChatInfos = groupChatInfos
    }
    
    init(dict: [String : Any]) {
        self.userID = dict["userID"] as? String ?? ""
        self.signUpDate = dict["signUpDate"] as? String ?? ""
        self.nickname = dict["nickname"] as? String ?? ""
        self.profileImageURL = dict["profileImageURL"] as? String ?? ""
        self.interestedJob = dict["interestedJob"] as? String ?? ""
        self.interestedDetailJobs = dict["interestedDetailJobs"] as? [String] ?? []
        self.subwayStation = dict["subwayStation"] as? String ?? ""
        self.subwayLines = dict["subwayLines"] as? [String] ?? []
        self.likeProjectIDs = dict["likeProjectIDs"] as? [String] ?? []
//        self.personalChatInfos = dict["personalChatInfos"] as? [UserChatInfo] ?? []
//        self.groupChatInfos = dict["groupChatInfos"] as? [UserChatInfo] ?? []
    }
}

struct UserForRegister {
    static var shared: User = User()
    private init() {}
}
