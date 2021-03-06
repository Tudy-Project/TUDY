//
//  Date+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/06/16.
//

import Foundation

extension Date {
    
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
