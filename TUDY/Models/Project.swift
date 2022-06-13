//
//  Project.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation

struct Project: Codable {
    var projectId: String
    var title: String
    var content: String
    var isRec: Bool
    var writerId: String
    var writeDate: String
    var imageUrl: String
    var wantedWorks: [String]
    var endDate: String
    var maxPeople: Int
    var favCnt: Int
    
    init (
        projectId: String = "",
        title: String = "",
        content: String = "",
        isRec: Bool = true,
        writerId: String = "",
        writeDate: String = "",
        imageUrl: String = "",
        wantedWorks: [String] = [],
        endDate: String = "",
        maxPeople: Int = 0,
        favCnt: Int = 0
    ) {
        self.projectId = projectId
        self.title = title
        self.content = content
        self.isRec = isRec
        self.writerId = writerId
        self.writeDate = writeDate
        self.imageUrl = imageUrl
        self.wantedWorks = wantedWorks
        self.endDate = endDate
        self.maxPeople = maxPeople
        self.favCnt = favCnt
    }

    init(dict: [String : Any]) {
        self.projectId = dict["projectId"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.content = dict["content"] as? String ?? ""
        self.isRec = dict["isRec"] as? Bool ?? true
        self.writerId = dict["writerId"] as? String ?? ""
        self.writeDate = dict["writeDate"] as? String ?? ""
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        self.wantedWorks = dict["wantedWorks"] as? [String] ?? []
        self.endDate = dict["wantedWorks"] as? String ?? ""
        self.maxPeople = dict["maxPeople"] as? Int ?? 0
        self.favCnt = dict["favCnt"] as? Int ?? 0
    }
}
