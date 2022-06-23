//
//  BottomSheetCollectionViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/06/13.
//

import UIKit

class BottomSheetCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "BottomSheetCell"
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .White
        label.numberOfLines = 2
        label.font = .body16
        return label
    }()
    
    lazy var contentsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.font = .caption12
        return label
    }()
    
    lazy var authorLabel: UILabel = {
       let label = UILabel()
        label.textColor = .White
        label.font = .caption12
        return label
    }()
    
    lazy var writeDateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.font = .caption12
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
      }
}

// MARK: - Methods
extension BottomSheetCell {
    
    private func configureUI() {
        contentView.backgroundColor = .DarkGray2
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(writeDateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-126)
            make.height.equalTo(40)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(20)
        }
        
        writeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalTo(authorLabel.snp.trailing).offset(7)
        }
        
    }
}
