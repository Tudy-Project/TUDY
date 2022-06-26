//
//  MessageCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/17.
//

import UIKit
import SDWebImage

class MessageCell: UICollectionViewCell {
    
    //MARK: - Properties
    var message: Message?
    
    var helper: MessageHelper?

    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
        
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
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .caption11
        label.textColor = .DarkGray5
        return label
    }()
    
    // MARK: - Lift Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let user = UserInfo.shared.user else { return }
        
        message = Message(content: "textView.text",
                          imageURL: "",
                          sender: user,
                          createdDate: Date().chatListDate())
        guard let message = message else { return }


//        print(message)
        helper = MessageHelper(message: message)

        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
        }
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        addSubview(bubbleContainer)
        addSubview(timeLabel)
//        print("1. DEBUG ! : \(UserInfo.shared.user?.userID)")
//        print("2. DEBUG ! : \(message.sender.userID)")
        guard let sender = UserInfo.shared.user else { return }
        if (message.sender.userID == sender.userID) {
            
            print("=========같다 즉, 나의 메세지=======")
            print("message.sender.userID : \(message.sender.userID)")
            print("sender.userID : \(sender.userID)")
            
            bubbleContainer.snp.makeConstraints { make in
                make.top.equalTo(userNameLabel.snp.bottom).offset(4)
                make.bottom.equalToSuperview()
                make.width.lessThanOrEqualTo(250)
                make.trailing.equalToSuperview().offset(-12)
            }
            timeLabel.snp.makeConstraints { make in
                make.trailing.equalTo(bubbleContainer.snp.leading).offset(-5)
                make.bottom.equalTo(bubbleContainer.snp.bottom)
            }
            
            profileImageView.isHidden = true
            userNameLabel.isHidden = true
        } else {
            print("=========다르다 즉, 너의 메세지=======")
            print("message.sender.userID : \(message.sender.userID)")
            print("sender.userID : \(sender.userID)")
            
            profileImageView.isHidden = false
            userNameLabel.isHidden = false
            
            bubbleContainer.snp.makeConstraints { make in
                make.top.equalTo(userNameLabel.snp.bottom).offset(4)
                make.bottom.equalToSuperview()
                make.width.lessThanOrEqualTo(250)
                make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            }
            
            timeLabel.snp.makeConstraints { make in
                make.leading.equalTo(bubbleContainer.snp.trailing).offset(10)
                make.bottom.equalTo(bubbleContainer.snp.bottom)
            }
        }

        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview()
//            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        bubbleContainer.backgroundColor = helper?.messageBackgroundColor
        textView.textColor = helper?.messageTextColor
        profileImageView.sd_setImage(with: helper?.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
