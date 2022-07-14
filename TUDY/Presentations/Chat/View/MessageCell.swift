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
    var message: Message? {
        didSet {
            
            configure()
            
        }
    }

    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    var timeLeftAnchor: NSLayoutConstraint!
    var timeRightAnchor: NSLayoutConstraint!
    

    private var messageTimes = [String]()
    
        
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
    
    lazy var dayTimeLabel: UILabel = {
        let label = UILabel().label(text: "", font: UIFont.caption12, color: UIColor.DarkGray5, numberOfLines: 1)
        return label
    }()
    
    // MARK: - Lift Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

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

        bubbleContainer.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
        }
            
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleContainer.snp.bottom)
        }
        
        timeLeftAnchor = timeLabel.leftAnchor.constraint(equalTo: bubbleContainer.rightAnchor, constant: 10)
        timeLeftAnchor.isActive = false
        
        timeRightAnchor = timeLabel.rightAnchor.constraint(equalTo: bubbleContainer.leftAnchor, constant: -5)
        timeRightAnchor.isActive = false

        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        addSubview(dayTimeLabel)
        dayTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
        }
    }
    
//    override func prepareForReuse() {
//        profileImageView.image = nil
//        userNameLabel.text = nil
//        textView.text = nil
//        timeLabel.text = nil
//
//        profileImageView.snp.removeConstraints()
//        userNameLabel.snp.removeConstraints()
//        bubbleContainer.snp.removeConstraints()
//        textView.snp.removeConstraints()
//        timeLabel.snp.removeConstraints()
//
//        layoutIfNeeded()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
 

        guard let message = message else { return }

        let helper = MessageHelper(message: message)
        
        textView.text = message.content

        timeLabel.text = message.createdDate.chatDate()
        userNameLabel.text = message.sender.nickname
//        dayTimeLabel.text = 

        messageTimes.append(message.createdDate)

        print("=============================================================MessageTimes=============================================================")
        print(messageTimes)
        
        
        
        bubbleLeftAnchor.isActive = helper.leftAnchorActive
        bubbleRightAnchor.isActive = helper.rightAnchorActive
        timeLeftAnchor.isActive = helper.leftAnchorActive
        timeRightAnchor.isActive = helper.rightAnchorActive

        bubbleContainer.backgroundColor = helper.messageBackgroundColor
        textView.textColor = helper.messageTextColor
        profileImageView.isHidden = helper.shouldHideProfileImage
        userNameLabel.isHidden = helper.shouldHideProfileImage

        if ((helper.profileImageUrl) != nil) {
            profileImageView.sd_setImage(with: helper.profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "defaultProfile")
        }
    }
}
