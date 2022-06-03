//
//  ChatListCell.swift
//  TUDY
//
//  Created by neuli on 2022/06/03.
//

import UIKit

//var chatNotification: Bool = true
//var bookMark: Bool = false
//var imageURL: String = ""
//var name: String = ""
//var latestMessage: String = ""

class ChatListCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "chatListCell"
    
    var chatListInfo: ChatList? {
        didSet {
            configureChatListCell()
        }
    }
    
    private let nameLabel = UILabel().label(text: "", font: .sub14)
    private let latestMessageLabel = UILabel().label(text: "", font: .body14)
    private let latestMessageDateLabel = UILabel().label(text: "", font: .caption11)
    
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

extension ChatListCell {
    
    // MARK: - methods
    func configureUI() {
        backgroundColor = .DarkGray3
        
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
        
        addSubview(latestMessageDateLabel)
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
        }
    }
    
    func configureChatListCell() {
        guard let chatListInfo = chatListInfo else { return }
        nameLabel.text = chatListInfo.name
        latestMessageLabel.text = chatListInfo.latestMessage
        latestMessageDateLabel.text = chatListInfo.latestMessageDate
        
//        guard let url = URL(string: user.profileImageUrl) else { return }
//        profileImageView.sd_setImage(with: url)
    }
}
