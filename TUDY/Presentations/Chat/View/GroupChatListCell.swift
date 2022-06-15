//
//  GroupChatListCell.swift
//  TUDY
//
//  Created by neuli on 2022/06/10.
//

import UIKit

class GroupChatListCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "GroupChatListCell"
    
    var chatInfo: ChatInfo? {
        didSet {
            configureGroupChatListCell()
        }
    }
    
    private let titleLabel = UILabel().label(text: "", font: .sub16, numberOfLines: 1)
    private let latestMessageLabel = UILabel().label(text: "", font: .body14, color: .LightGray2, numberOfLines: 1)
    private let latestMessageDateLabel = UILabel().label(text: "", font: .caption11)
    private let participantsCountButton = UIButton().peopleCountButton()
    private let masterButton = UIButton().button(text: "방장",
                                                 font: .caption11,
                                                 fontColor: .White,
                                                 backgroundColor: .PointBlue,
                                                 cornerRadius: 8)
    private let notificationCountButton = UIButton().notificationCountButton()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupChatListCell {
    
    // MARK: - methods
    private func configureUI() {
        backgroundColor = .DarkGray1
        
        masterButton.snp.makeConstraints { make in
            make.width.equalTo(39)
            make.height.equalTo(16)
        }
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, participantsCountButton, masterButton])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 6
        
        titleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(180)
        }
        
        addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalToSuperview().offset(20)
        }
        
        addSubview(latestMessageLabel)
        latestMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(272)
        }
        
        addSubview(latestMessageDateLabel)
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(30)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        }
        
        masterButton.isHidden = true
    }
    
    private func configureGroupChatListCell() {
        guard let chatInfo = chatInfo else { return }
        
        FirebaseUserChatInfo.fetchUserChatInfo(chatInfoID: chatInfo.chatInfoID) { [weak self] userChatInfo in
            switch userChatInfo.bookMark {
            case true:
                self?.titleLabel.text = "📍 \(chatInfo.chatTitle)"
            case false:
                self?.titleLabel.text = "  \(chatInfo.chatTitle)"
            }
            
            if userChatInfo.dontReadCount != 0 {
                self?.addSubViewNotificationCount(count: userChatInfo.dontReadCount)
            }
        }
        
        latestMessageLabel.text = "  \(chatInfo.latestMessage)"
        latestMessageDateLabel.text = chatInfo.latestMessageDate
        participantsCountButton.setTitle("\(chatInfo.participantIDs.count)", for: .normal)
        
        if FirebaseUser.getUserID() == chatInfo.projectMasterID {
            masterButton.isHidden = false
        }
    }
    
    private func addSubViewNotificationCount(count: Int) {
        notificationCountButton.setTitle("\(count)", for: .normal)
        addSubview(notificationCountButton)
        notificationCountButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}

