//
//  MessageRequest.swift
//  TUDY
//
//  Created by neuli on 2022/07/13.
//

import Foundation

struct MessageRequest<T: Codable>: Codable {
    private var to: String
    private var notificationInfo: NotificationInfo
    private var data: T
    
    init(title: String, body: String, data: T, to: String) {
        self.to = to
        self.notificationInfo = NotificationInfo(title: title, body: body)
        self.data = data
    }
}
