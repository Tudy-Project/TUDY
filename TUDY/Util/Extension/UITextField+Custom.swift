//
//  UITextField+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

extension UITextField {
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textFiled = UITextField()
        textFiled.borderStyle = .none
        textFiled.font = .body14
        textFiled.textColor = .White
        textFiled.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
                                                        [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return textFiled
    }
    
    func underLine() {
        let border = CALayer()
        border.frame = CGRect(x: -3, y: self.frame.size.height + 13, width: self.frame.width + 3, height: 2)
        border.borderColor = UIColor.White.cgColor
        border.borderWidth = 1
        self.layer.addSublayer(border)
    }
}
