//
//  WorkCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/09.
//

import UIKit

class WorkCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var workCircle: UIView = {
        let view = UIView()
        view.frame.size.width = contentView.frame.width * 0.4
        view.frame.size.height = contentView.frame.width * 0.4
        view.layer.cornerRadius = view.frame.width / 2
        print("hey ! \(view.frame.width)")
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var workIcon: UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    lazy var workTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.sub16
        return label
    }()
    
    // MARK: - Lift Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}

extension WorkCell {
    private func configureUI() {
        contentView.addSubview(workCircle)
        workCircle.addSubview(workIcon)
        contentView.addSubview(workTitle)
        
        workCircle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        
        workIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
            make.centerX.centerY.equalToSuperview()
        }
        
        workTitle.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
        
    }
}
