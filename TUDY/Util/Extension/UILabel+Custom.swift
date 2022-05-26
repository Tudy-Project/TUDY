//
//  UILabel+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

extension UILabel {
    
    func label(text: String, font: UIFont, color: UIColor? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        if let color = color {
            label.textColor = color
        }
        return label
    }
}