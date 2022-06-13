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
        navigationController?.navigationBar.backgroundColor = .DarkGray1
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .DarkGray1
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func navDisappear() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func tabAppear() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.barTintColor = .DarkGray1
        tabBarController?.tabBar.isTranslucent = false
    }
    
    func tabDisappear() {
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
}
