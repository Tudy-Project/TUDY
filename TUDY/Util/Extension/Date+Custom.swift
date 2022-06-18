//
//  Date+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/06/16.
//

import Foundation

extension Date {
    
    func projectDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func chatListDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func chatDate() -> String {
        let chatDateFormatter = DateFormatter()
        chatDateFormatter.dateFormat = "a h:mm"
        return chatDateFormatter.string(from: self)
    }
}
