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
    
    func circleImage(width: CGFloat, height: CGFloat) -> UIView {
        let view = UIView()
        
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }
    
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(-constant)
        }
    }
}
