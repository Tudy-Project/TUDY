//
//  ChatInputAccessoryView.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/16.
//

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    func inputView(_ inputView: ChatInputAccessoryView, wantsToSend message: String)
}

class ChatInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ChatInputAccessoryViewDelegate?
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.tintColor = .white
//        button.addTarget(self, action: #selector(handlephoto), for: .touchUpInside)
        return button
    }()
    
    lazy var messageInputTextView: UITextView = {
        let textview = UITextView()
        textview.font = .sub14
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.LightGray1.cgColor
        textview.textColor = .black
        textview.textContainer.lineFragmentPadding = 15
        textview.isScrollEnabled = false
        textview.layer.cornerRadius = 15
        textview.backgroundColor = .white
        return textview
    }()
    
    lazy var sendButton: UIButton = {
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
        photoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-4)
            make.leading.equalToSuperview()
            make.width.height.equalTo(50)
        }

        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(4)
            make.width.height.equalTo(50)
        }
        
        addSubview(messageInputTextView)
        messageInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(4)
            make.leading.equalTo(photoButton.snp.trailing)
            make.trailing.equalTo(sendButton.snp.leading).offset(4)
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

    @objc func handleSendMessage() {
        guard let message = messageInputTextView.text else { return }
        delegate?.inputView(self, wantsToSend: message)
    }
}


