//
//  WorkCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/09.
//

import UIKit

class WorkCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var workIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = imageview.frame.width / 2
        imageview.clipsToBounds = true
        return imageview
    }()
    
    lazy var workTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lift Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
}

extension WorkCell {
    private func configureUI() {
        contentView.addSubview(workIcon)
        contentView.addSubview(workTitle)
        
        workIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        workTitle.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
    }
}
