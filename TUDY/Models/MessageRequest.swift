//
//  MessageRequest.swift
//  TUDY
//
//  Created by neuli on 2022/07/13.
//

import Foundation

struct MessageRequest: Codable {
    private var to: String
    private var notification: NotificationInfo
    private var data: UserNotification
    
    init(title: String, body: String, data: UserNotification, to: String) {
        self.to = to
        self.notification = NotificationInfo(title: title, body: body)
        self.data = data
    }
}
