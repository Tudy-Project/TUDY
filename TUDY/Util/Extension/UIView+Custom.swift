//
//  UIView+Custom.swift
//  TUDY
//
//  Created by jamescode on 2022/05/28.
//

import UIKit

extension UIView {
    
    func view(backgroundColor: UIColor? = nil) -> UIView {
        let view = UIView()
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor
        }
        return view
    }
    
    func notificationDot() -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(5)
            make.height.equalTo(5)
        }
        view.layer.cornerRadius = 5 / 2
        view.backgroundColor = .PointRed
        return view
    }
    
    func grayBlock() -> UIView {
        let view = UIView()
        view.backgroundColor = .DarkGray5
        return view
    }
}
