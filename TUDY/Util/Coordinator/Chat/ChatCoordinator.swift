//
//  ChatCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

final class ChatCoordinator: ChatCoordinatorProtocol {
    
    // MARK: - Properties
    
    var chatListViewController: ChatListViewController
    var chatViewController: ChatProtocol?
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chat
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatListViewController = ChatListViewController()
    }
    
    func start() {
        chatListViewController.didSendEventClosure = { event, chatInfo in
            switch event {
            case .showChat:
                self.pushChatViewController(chatInfo: chatInfo)
            }
        }
        self.navigationController.pushViewController(self.chatListViewController, animated: true)
    }
}

extension ChatCoordinator {
    
    func pushChatViewController(chatInfo: ChatInfo) {
        switch chatInfo.chatState {
        case .groupChat:
            chatViewController = GroupChatViewController()
        case .personalChat:
            chatViewController = PersonalChatViewController()
        }
        chatViewController?.chatInfo = chatInfo
        
        if let chatViewController = chatViewController as? UIViewController {
            navigationController.pushViewController(chatViewController, animated: true)
        }
    }
}

// MARK: - CoordinatorFinishDelegate

extension ChatCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
