//
//  UIView+Custom.swift
//  TUDY
//
//  Created by jamescode on 2022/05/28.
//

import UIKit

extension UIView {
    func grayBlock() -> UIView {
        let view = UIView()
        view.backgroundColor = .DarkGray5
        return view
    }
    
    func circleImage() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }
}
