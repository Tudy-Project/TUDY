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
    weak var loginDelegate: LoginCheckDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chat
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatListViewController = ChatListViewController()
    }
    
    func start() {
        chatListViewController.didSendEventClosure = { event in
            switch event {
            case .showChat(let chatInfo):
                self.pushChatViewController(chatInfo: chatInfo)
            case .showLogin:
                self.loginDelegate?.prepareLoginCoordinator()
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
            chatViewController = NewPersonalChatViewController()
        }
        chatViewController?.chatInfo = chatInfo
        
        if let chatViewController = chatViewController as? UIViewController {
            navigationController.pushViewController(chatViewController, animated: true)
        }
    }
    
    func makePersonalChatViewController(with projectWriter: User) {
        chatListViewController.makePersonalChat(with: projectWriter)
    }
    
    func moveGroupChatViewController(chatInfo: ChatInfo) {
        navigationController.popViewController(animated: true)
        
        let groupChatViewController = GroupChatViewController()
        groupChatViewController.chatInfo = chatInfo
        navigationController.pushViewController(groupChatViewController, animated: true)
    }
    
    func pushNotificationChatViewController(chatInfoID: String) {
        let chatListViewController = ChatListViewController()
        chatListViewController.pushNotificationChatViewController(chatInfoID: chatInfoID)
    }
}

// MARK: - CoordinatorFinishDelegate

extension ChatCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
