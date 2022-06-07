//
//  Project.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation

struct Project {
    let projectId: Int
    let writerUserId: Int
    let writeDate: String
    let title: String
    let content: String
    let relatedWork: [String]
    let endDate: String
    let maxPeople: Int
    let likeNum: Int
    
    init (
        projectId: Int = 0,
        writerUserId: Int = 0,
        writeDate: String = "",
        title: String = "",
        content: String = "",
        relatedWork: [String] = [],
        endDate: String = "",
        maxPeople: Int = 0,
        likeNum: Int = 0
    ) {
        self.projectId = projectId
        self.writerUserId = writerUserId
        self.writeDate = writeDate
        self.title = title
        self.content = content
        self.relatedWork = relatedWork
        self.endDate = endDate
        self.maxPeople = maxPeople
        self.likeNum = likeNum
    }
}
