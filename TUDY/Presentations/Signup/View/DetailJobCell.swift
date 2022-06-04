//
//  DetailJobCell.swift
//  TUDY
//
//  Created by neuli on 2022/05/29.
//

import UIKit

class DetailJobCell: UICollectionViewCell {
    
    // MARK: - Properties
    let button: DetailJobButton = {
        let button = DetailJobButton()
        button.isTap = false
        button.backgroundColor = .DarkGray1
        button.titleLabel?.font = .caption12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.DarkGray5.cgColor
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension DetailJobCell {
    
    // MARK: - Methods
    func configureUI() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}

