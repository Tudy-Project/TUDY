//
//  TabBarPage.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import Foundation
import UIKit

enum TabBarPage: CaseIterable {
    
    case home
    case chat
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .chat
        default:
            return nil
        }
    }
    
    func pageTitle() -> String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "채팅"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .chat:
            return 1
        }
    }
    
    // func pageIcon() -> UIImage {}
    // func pageSelectedColor() -> UIColor {}
    // func pageDeselectedColor() -> UIColor {}
}
