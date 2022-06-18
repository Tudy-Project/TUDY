//
//  MessageCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/17.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    lazy var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.backgroundColor = .LightGray1
        imageview.layer.cornerRadius = 32 / 2
        return imageview
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "호진"
        label.textColor = .white
        label.font = UIFont.caption11
        return label
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .DarkGray5
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var textView: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = .clear
        textview.font = UIFont.sub14
        textview.isScrollEnabled = false
        textview.isEditable = false
        textview.textColor = .white
        return textview
    }()
    
//    lazy var
    

    
    // MARK: - Lift Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-4)
            make.width.height.equalTo(32)
        }
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        addSubview(bubbleContainer)
        bubbleContainer.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.bottom.equalToSuperview().offset(-4)
            make.width.lessThanOrEqualTo(250)
        }
        
        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
