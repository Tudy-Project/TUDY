//
//  PersonalChatViewController.swift
//  TUDY
//
//  Created by neuli on 2022/06/13.
//

import UIKit

class PersonalChatViewController: UIViewController {
    
    // MARK: - Properties
    var chatInfo: ChatInfo? {
        didSet {
            configureUI()
        }
    }
    
    private lazy var chatinputView: ChatInputAccessoryView = {
        let iv = ChatInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        return iv
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navAppear()
        tabDisappear()
    }
    
    override var inputAccessoryView: UIView? {
        get { return chatinputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension PersonalChatViewController {
    
    // MARK: - Methods
    private func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .DarkGray1
    }
    
    private func configureNavigationBar() {
        navigationItem.title = chatInfo?.chatTitle
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "초대", style: .plain, target: self, action: #selector(invitedButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .PointBlue
    }
}
// MARK: - extensions
extension PersonalChatViewController {
    @objc func invitedButtonClicked() {
        let invitedVC = InvitedViewController()
        invitedVC.modalPresentationStyle = .overFullScreen
        self.present(invitedVC, animated: false, completion: nil)
    }
}



// MARK: - ChatProtocol
extension PersonalChatViewController: ChatProtocol {
    
}
