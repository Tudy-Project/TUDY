//
//  ChatListCell.swift
//  TUDY
//
//  Created by neuli on 2022/06/03.
//

import UIKit

class PersonalChatListCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "PersonalChatListCell"
    
    var chatInfo: ChatInfo? {
        didSet {
            configurePersonalChatListCell()
        }
    }
    
    private let titleLabel = UILabel().label(text: "", font: .sub16)
    private let latestMessageLabel = UILabel().label(text: "", font: .body14, color: .LightGray2, numberOfLines: 2)
    private let latestMessageDateLabel = UILabel().label(text: "", font: .caption12, color: .LightGray2, numberOfLines: 1)
    private let notificationCountButton = UIButton().notificationCountButton()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .White
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonalChatListCell {
    
    // MARK: - methods
    private func configureUI() {
        backgroundColor = .DarkGray1
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, latestMessageLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        latestMessageLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        addSubview(latestMessageDateLabel)
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
            make.width.lessThanOrEqualTo(60)
        }

    }
    
    private func configurePersonalChatListCell() {
        guard let chatInfo = chatInfo else { return }
        
        let userID = FirebaseUser.getUserID()
        for id in chatInfo.participantIDs where id != userID {
            FirebaseUser.fetchOtherUser(userID: id) { [weak self] user in
                self?.setTitle(nickname: user.nickname)
            }
        }
        
        latestMessageLabel.text = chatInfo.latestMessage
        latestMessageDateLabel.text = chatInfo.latestMessageDate.chatListDate()
        
        addSubViewNotificationCount(count: 99)
        
//        guard let url = URL(string: user.profileImageUrl) else { return }
//        profileImageView.sd_setImage(with: url)
    }
    
    private func addSubViewNotificationCount(count: Int) {
        notificationCountButton.setTitle("\(count)", for: .normal)
        addSubview(notificationCountButton)
        notificationCountButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-28)
        }
    }
    
    private func setTitle(nickname: String) {
        guard let chatInfo = chatInfo else { return }
        
        let pin = NSMutableAttributedString(string: "📍 ",
                                            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
        let title = NSMutableAttributedString(string: nickname,
                                              attributes: [NSAttributedString.Key.font : UIFont.sub16,
                                                           NSAttributedString.Key.foregroundColor : UIColor.White])
        pin.append(title)
        FirebaseUserChatInfo.fetchUserChatInfo(chatInfoID: chatInfo.chatInfoID) { [weak self] userChatInfo in
            switch userChatInfo.bookMark {
            case true:
                self?.titleLabel.attributedText = pin
            case false:
                self?.titleLabel.text = "\(nickname)"
            }
        }
    }
}
