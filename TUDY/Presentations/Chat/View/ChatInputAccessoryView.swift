//
//  ChatInputAccessoryView.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/16.
//

import UIKit

class ChatInputAccessoryView: UIView {
    
    // MARK: - Properties
    private lazy var photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlephoto), for: .touchUpInside)
        return button
    }()
    
    private let messageInputTextView: UITextView = {
        let textview = UITextView()
        textview.font = .sub16
        textview.isScrollEnabled = false
        textview.layer.cornerRadius = 20
        textview.backgroundColor = .white
        return textview
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sendmessage"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .DarkGray2
        autoresizingMask = .flexibleHeight
        
        addSubview(photoButton)
        addSubview(sendButton)
        addSubview(messageInputTextView)

        photoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(50)
        }

        sendButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(8)
            make.width.height.equalTo(50)
        }
        
        messageInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4).inset(12)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(4)
            make.leading.equalTo(photoButton.snp.trailing).offset(4)
            make.trailing.equalTo(sendButton.snp.leading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}

// MARK: - Extension

extension ChatInputAccessoryView {
    @objc func handlephoto() {
        print("PHOTO")
    }
    
    @objc func handleSendMessage() {
        print("HEYYYY")
    }
}


