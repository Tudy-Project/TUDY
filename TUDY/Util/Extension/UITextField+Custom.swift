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
        textFiled.font = .caption12
        textFiled.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
                                                        [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height + 8, width: self.frame.width, height: 2)
        border.borderColor = UIColor.black.cgColor
        textFiled.layer.addSublayer(border)
        return textFiled
    }
}
