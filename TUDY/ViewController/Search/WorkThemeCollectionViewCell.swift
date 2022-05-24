//
//  WorkThemeCollectionViewCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/24.
//

import UIKit

class WorkThemeCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "cell"
    
    lazy var workThemeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorkThemeCollectionViewCell {
    func configureUI() {
        self.contentView.addSubview(workThemeButton)
        
        workThemeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.height.equalTo(10)
        }
    }
}
