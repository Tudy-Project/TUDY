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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navAppear()
        tabDisappear()
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
