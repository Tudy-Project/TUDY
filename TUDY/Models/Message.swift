//
//  Message.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

struct Message: Codable {
    let content: String
    let sender: User
    let createdDate: String
}
