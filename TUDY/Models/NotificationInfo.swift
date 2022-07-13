//
//  Notification.swift
//  TUDY
//
//  Created by neuli on 2022/07/13.
//

import Foundation

struct NotificationInfo: Codable {
    private var title: String
    private var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
