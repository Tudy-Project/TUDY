//
//  HashtageCell.swift
//  TUDY
//
//  Created by neuli on 2022/06/24.
//

import UIKit

class HashtagCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HashtagCell"
    
    let label = UILabel().label(text: "", font: UIFont.caption11)
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        addSubview(label)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.backgroundColor = .DarkGray3
        label.textColor = .White
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(24)
        }
    }
}
