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
            return ""
        case .chat:
            return ""
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
    
    func selecedIcon() -> UIImage {
        switch self {
        case .home:
            guard let image = UIImage(named: "home-selected") else { return UIImage() }
            return image
        case .chat:
            guard let image = UIImage(named: "chat-selected") else { return UIImage() }
            return image
        }
    }
    func unselecedIcon() -> UIImage {
        switch self {
        case .home:
            guard let image = UIImage(named: "home-unselected") else { return UIImage() }
            return image
        case .chat:
            guard let image = UIImage(named: "chat-unselected") else { return UIImage() }
            return image
        }
    }
}
