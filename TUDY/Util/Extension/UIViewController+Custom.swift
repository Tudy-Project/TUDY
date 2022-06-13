//
//  UIViewController+Custom.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/13.
//

import Foundation
import UIKit

extension UIViewController {
    func navAppear() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .DarkGray1
    }
    
    func navDisappear() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func tabAppear() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.barTintColor = .DarkGray1
    }
    
    func tabDisappear() {
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
}
