//
//  BottomSheetCollectionViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/06/13.
//

import UIKit
import SDWebImage

class BottomSheetCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "BottomSheetCell"
    
    var recruitButton = UIButton().button(text: "", font: .caption12, fontColor: .White, cornerRadius: 17 / 2)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .White
        label.numberOfLines = 0
        label.font = .sub16
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
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .White
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 13 / 2
        return imageView
    }()
    
    lazy var projectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .White
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}

// MARK: - Methods
extension BottomSheetCell {
    
    func configureUIWithNoImage() {
        contentView.backgroundColor = .DarkGray2
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.lessThanOrEqualTo(44)
        }
        
        contentView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-46)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(writeDateLabel)
        writeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalTo(authorLabel.snp.trailing).offset(7)
        }
        
    }
    
    func configureUIWithImage() {
        contentView.backgroundColor = .DarkGray2
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-126)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-46)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-126)
        }
        
        contentView.addSubview(projectImageView)
        projectImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-20)
            make.width.equalTo(87)
            make.height.equalTo(87)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(writeDateLabel)
        writeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(9)
            make.leading.equalTo(authorLabel.snp.trailing).offset(7)
        }
    }
    
    func setRecruitTrue() {
        contentView.addSubview(recruitButton)
        recruitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(47)
            make.height.equalTo(17)
        }
        recruitButton.setTitle("모집중", for: .normal)
        recruitButton.backgroundColor = .PointBlue
    }
    
    func setRecruitFalse() {
        contentView.addSubview(recruitButton)
        recruitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(56)
            make.height.equalTo(17)
        }
        recruitButton.setTitle("모집완료", for: .normal)
        recruitButton.backgroundColor = .DarkGray5
    }
}
