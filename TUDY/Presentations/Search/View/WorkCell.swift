//
//  WorkCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/09.
//

import UIKit

class WorkCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    lazy var isSelectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10
        return view
    }()

    lazy var checkIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "check_white")
        return imageview
    }()
    
    lazy var workCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
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
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                contentView.addSubview(isSelectedView)
                isSelectedView.addSubview(checkIcon)
                
                isSelectedView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                checkIcon.snp.makeConstraints { make in
                    make.width.height.equalTo(20)
                    make.centerX.centerY.equalToSuperview()
                }
                
            } else {
                isSelectedView.removeFromSuperview()
            }
        }
    }
}
