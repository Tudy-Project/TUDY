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
        toolbar.barTintColor = .black
        toolbar.isTranslucent = false
        return toolbar
    }
}
