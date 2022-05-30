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
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.sub14
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }
    
    func nextButtonLayout(view: UIView) {
        self.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(13)
            make.height.equalTo(50)
        }
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
