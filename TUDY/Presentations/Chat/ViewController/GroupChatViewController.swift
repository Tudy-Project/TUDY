//
//  ChatViewController.swift
//  TUDY
//
//  Created by neuli on 2022/06/13.
//

import UIKit

class GroupChatViewController: UICollectionViewController {
    
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

extension GroupChatViewController {
    
    // MARK: - Methods
    private func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .DarkGray1
    }
    
    private func configureNavigationBar() {
        navigationItem.title = chatInfo?.chatTitle
        navigationController?.navigationBar.backgroundColor = .systemBlue
    }
}

// MARK: - ChatProtocol
extension GroupChatViewController: ChatProtocol {
    
}
