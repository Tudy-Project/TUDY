//
//  fastSearchCell.swift
//  TUDY
//
//  Created by jamescode on 2022/06/13.
//

import UIKit

class FastSearchCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "FastSearchCell"
    
    lazy var workCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .White
        return view
    }()
    
    lazy var workIcon: UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    lazy var workTitle: UILabel = {
        let label = UILabel()
        label.textColor = .White
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

extension FastSearchCell {
    private func configureUI() {
        contentView.addSubview(workCircle)
        contentView.addSubview(workTitle)
        workCircle.addSubview(workIcon)
    
    workCircle.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(10)
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
