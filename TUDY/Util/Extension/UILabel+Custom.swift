//
//  UILabel+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

extension UILabel {
    
    func label(text: String, font: UIFont, color: UIColor? = nil, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.numberOfLines = numberOfLines
        if let color = color {
            label.textColor = color
        } else {
            label.textColor = .White
        }
        return label
    }
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            self.attributedText = attributedString
        }
    }
}
