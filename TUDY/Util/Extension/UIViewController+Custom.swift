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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .DarkGray1
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    func navDisappear() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func tabAppear() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.barTintColor = .DarkGray1
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.backgroundColor = .DarkGray1
    }
    
    func tabDisappear() {
        navigationController?.view.backgroundColor = .DarkGray1
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func showToastMessage(text: String) {

        let width: CGFloat = 330
        let toastMessageLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - (width / 2),
                                                      y: view.frame.size.height - 150,
                                                      width: 330,
                                                      height: 48))
        toastMessageLabel.backgroundColor = .DarkGray5.withAlphaComponent(0.9)
        toastMessageLabel.textAlignment = .center
        toastMessageLabel.layer.cornerRadius = 10
        toastMessageLabel.clipsToBounds = true
        toastMessageLabel.text = text
        toastMessageLabel.numberOfLines = 0
        toastMessageLabel.textColor = .White
        toastMessageLabel.font = .body14
        view.addSubview(toastMessageLabel)
        UIView.animate(withDuration: 0.7, delay: 1.0, options: .curveEaseOut) {
            toastMessageLabel.alpha = 0.0
        } completion: { _ in
            toastMessageLabel.removeFromSuperview()
        }
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
