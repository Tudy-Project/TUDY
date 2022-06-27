//
//  DevelopCell.swift
//  TUDY
//
//  Created by jamescode on 2022/06/08.
//

import UIKit
import SnapKit

class DevelopCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "developCell"
    
    let button: DevelopButton = {
        let button = DevelopButton()
        button.isTap = false
        button.backgroundColor = .DarkGray2
        button.titleLabel?.font = .caption12
        button.setTitleColor(UIColor.White, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.LightGray4.cgColor
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

extension DevelopCell {
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
