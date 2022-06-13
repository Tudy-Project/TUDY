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
    
    var chatListInfo: ChatInfo? {
        didSet {
            configurePersonalChatListCell()
        }
    }
    
    private let nameLabel = UILabel().label(text: "", font: .sub14)
    private let latestMessageLabel = UILabel().label(text: "", font: .body14)
    private let latestMessageDateLabel = UILabel().label(text: "", font: .caption11)
    private let participantsCountButton = UIButton().peopleCountButton()
    private let dot = UIView().notificationDot()
    
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
    func configureUI() {
        backgroundColor = .DarkGray1
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, latestMessageLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        addSubview(dot)
        dot.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        addSubview(latestMessageDateLabel)
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        addSubview(participantsCountButton)
        participantsCountButton.isEnabled = false
        participantsCountButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(35)
            make.height.equalTo(16)
        }
    }
    
    func configurePersonalChatListCell() {
        guard let chatListInfo = chatListInfo else { return }
        
        switch chatListInfo.bookMark {
        case true:
            nameLabel.text = "📍 \(chatListInfo.chatTitle)"
        case false:
            nameLabel.text = chatListInfo.chatTitle
        }
        latestMessageLabel.text = chatListInfo.latestMessage
        latestMessageDateLabel.text = chatListInfo.latestMessageDate
        participantsCountButton.setTitle("\(chatListInfo.participantIDs.count)", for: .normal)
        
//        guard let url = URL(string: user.profileImageUrl) else { return }
//        profileImageView.sd_setImage(with: url)
    }
}
