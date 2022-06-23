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
        guard let userId = UserInfo.shared.user?.userID else { return UIColor() }
        
        if userId == message.sender.userID {
            return .black
        } else {
            return .white
        }
    }
    
    var rightAnchorActive: Bool {
        guard let userId = UserInfo.shared.user?.userID else { return true }
            return message.sender.userID == userId
    }
    
    var leftAnchorActive: Bool {
        guard let userId = UserInfo.shared.user?.userID else { return true }
            return !(message.sender.userID == userId)
    }
    
    var shouldHideProfileImage: Bool {
        guard let userId = UserInfo.shared.user?.userID else { return true }
            return message.sender.userID == userId
    }
    
    var profileImageUrl: URL? {
        guard let user = UserInfo.shared.user else { return nil }
        return URL(string: user.profileImageURL)
    }
    
    init(message: Message) {
        self.message = message
    }
}
