//
//  UIButton+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit
import SnapKit

extension UIButton {
    
    func nextButton(text: String = "다음") -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.sub16
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.changeIsEnabledFalse()
        return button
    }
    
    func nextButtonLayout(view: UIView) {
        self.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.height.equalTo(48)
        }
    }
    
    func changeIsEnabledTrue() {
        self.isEnabled = true
        self.backgroundColor = .DarkGray4
    }
    
    func changeIsEnabledFalse() {
        self.isEnabled = false
        self.backgroundColor = .DarkGray2
    }
    
    func imageButton(imageName: String) -> UIButton {
        let button = UIButton()
        if  let image = UIImage(systemName: imageName) {
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: imageName)
                button.setImage(image, for: .normal)
        }
        return button
    }
}
