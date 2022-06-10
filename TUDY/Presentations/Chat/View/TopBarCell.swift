//
//  TopBarCell.swift
//  TUDY
//
//  Created by neuli on 2022/06/10.
//

import UIKit

class TopBarCell: UICollectionViewCell {
    
    // MARK: - Properties
    let label = UILabel().label(text: "", font: .sub14, color: .White)
    private let dot = UIView().notificationDot()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopBarCell {
    
    // MARK: - Methods
    func configureUI() {
        
        contentView.backgroundColor = .DarkGray1
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-9)
        }
        
        contentView.addSubview(dot)
        dot.snp.makeConstraints { make in
            make.top.equalTo(label.snp.top).offset(-5)
            make.leading.equalTo(label.snp.trailing).offset(5)
        }
    }
}
