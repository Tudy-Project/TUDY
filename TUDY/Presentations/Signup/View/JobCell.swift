//
//  JobCell.swift
//  TUDY
//
//  Created by neuli on 2022/05/29.
//

import UIKit
import SnapKit

class JobCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "JobCellReuseIdentifier"
    let button: JobButton = {
        let button = JobButton()
        button.backgroundColor = .DarkGray1
        button.titleLabel?.font = .sub20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.DarkGray5.cgColor
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

extension JobCell {
    
    // MARK: - Methods
    func configureUI() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(56)
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
