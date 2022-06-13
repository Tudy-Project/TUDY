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
    
    var chatListInfo: ChatInfo? {
        didSet {
            configureGroupChatListCell()
        }
    }
    
    private let titleLabel = UILabel().label(text: "", font: .sub14, numberOfLines: 1)
    private let latestMessageLabel = UILabel().label(text: "", font: .body14)
    private let latestMessageDateLabel = UILabel().label(text: "", font: .caption11)
    private let participantsCountButton = UIButton().peopleCountButton()
    private let dot = UIView().notificationDot()
    private let masterButton = UIButton().button(text: "방장",
                                                 font: .caption11,
                                                 fontColor: .White,
                                                 backgroundColor: .PointBlue,
                                                 cornerRadius: 8)
    
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
    func configureUI() {
        backgroundColor = .DarkGray1
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        masterButton.snp.makeConstraints { make in
            make.width.equalTo(39)
            make.height.equalTo(16)
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, latestMessageLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        addSubview(latestMessageDateLabel)
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
        }
        
        addSubview(dot)
        dot.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
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
    
    func configureGroupChatListCell() {
        guard let chatListInfo = chatListInfo else { return }
        
        switch chatListInfo.bookMark {
        case true:
            titleLabel.text = "📍 \(chatListInfo.chatTitle)"
        case false:
            titleLabel.text = chatListInfo.chatTitle
        }
        latestMessageLabel.text = chatListInfo.latestMessage
        latestMessageDateLabel.text = chatListInfo.latestMessageDate
        participantsCountButton.setTitle("\(chatListInfo.participantIDs.count)", for: .normal)
        
//        if CommonFirebaseDatabaseNetworkService.getUserID() == chatListInfo.projectMasterID {
//            addSubview(masterLabel)
//            masterLabel.snp.makeConstraints { make in
//                make.top.equalTo(titleLabel.snp.top)
//                make.leading.equalTo(titleLabel.snp.trailing).offset(8)
//            }
//        }
    }
}

