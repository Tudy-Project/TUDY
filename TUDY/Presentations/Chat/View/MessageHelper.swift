//
//  MessageHelper.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/18.
//

import Foundation
import UIKit

struct MessageHelper {
 
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        if let userId = UserInfo.shared.user?.userID {
            if message.sender.userID == userId {
                return .white
            } else {
                return .DarkGray5
            }
        }
        return UIColor()
    }
    
    var messageTextColor: UIColor {
        if let userId = UserInfo.shared.user?.userID {
            if message.sender.userID == userId {
                return .black
            } else {
                return .white
            }
        }
        return UIColor()
    }
    
    init(message: Message) {
        self.message = message
    }
}
