//
//  UIToolbar+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/27.
//

import UIKit

extension UIToolbar {
    
    func toolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = .DarkGray2
        toolbar.isTranslucent = false
        return toolbar
    }
    
    func changeColorDarkGray2() {
        self.barTintColor = .DarkGray2
    }
    
    func changeColorDarkGray4() {
        self.barTintColor = .DarkGray4
    }
}
