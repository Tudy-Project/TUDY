//
//  ChatState.swift
//  TUDY
//
//  Created by neuli on 2022/06/02.
//

import Foundation

enum ChatState: String, Hashable, Codable {
    case personalChat = "개인챗"
    case groupChat = "단체챗"
}
