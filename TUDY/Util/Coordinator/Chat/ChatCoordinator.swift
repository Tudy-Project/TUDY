//
//  ChatCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

final class ChatCoordinator: ChatCoordinatorProtocol {
    
    var chatListViewController: ChatListViewController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chat
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatListViewController = ChatListViewController()
    }
    
    func start() {
        self.chatListViewController.didSendEventClosure = { [weak self] event, chatPartners in
            // 채팅 상대 chatPartners
            switch event {
            case .showPersonalChat:
                self?.showPersonalChat(chatPartners)
            case .showGroupChat:
                self?.showGroupChat(chatPartners)
            }
        }
        self.navigationController.pushViewController(self.chatListViewController, animated: true)
    }
}

// MARK: - ChatCoordinatorProtocol
extension ChatCoordinator {
    
    // 채팅 상대 chatPartners
    func showPersonalChat(_ chatPartners: [String]) {
        let personalChatViewController = PersonalChatViewController()
        navigationController.pushViewController(personalChatViewController, animated: true)
    }
    
    func showGroupChat(_ chatPartners: [String]) {
        let groupChatViewController = GroupChatViewController()
        navigationController.pushViewController(groupChatViewController, animated: true)
    }
}

// MARK: - CoordinatorFinishDelegate
extension ChatCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
