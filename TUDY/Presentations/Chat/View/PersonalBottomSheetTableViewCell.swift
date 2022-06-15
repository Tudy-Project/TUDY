//
//  PersonalBottomSheetTableViewCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/15.
//

import UIKit

class PersonalBottomSheetTableViewCell: UITableViewCell {

    
    // MARK: - properties
    static let reuseIdentifier = "PersonalBottomSheetTableViewCell"
    
    private let titleLabel = UILabel().label(text: "", font: .sub16, numberOfLines: 1)
    private let participantsCountButton = UIButton().peopleCountButton()

    var chatListInfo: ChatInfo? {
        didSet {
            configureGroupChatListCell()
        }
    }
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonalBottomSheetTableViewCell {

    private func configureUI() {
        backgroundColor = .DarkGray1

        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, participantsCountButton])
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
    }
    
    
    private func configureGroupChatListCell() {
        guard let chatListInfo = chatListInfo else { return }

        titleLabel.text = "  \(chatListInfo.chatTitle)"
        participantsCountButton.setTitle("\(chatListInfo.participantIDs.count)", for: .normal)
    }

}
