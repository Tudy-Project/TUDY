//
//  UIButton+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

extension UIButton {
    
    func nextButton(text: String = "다음") -> UIButton {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    func imageButton(imageName: String) -> UIButton {
        let button = UIButton()
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        return button
    }
}
