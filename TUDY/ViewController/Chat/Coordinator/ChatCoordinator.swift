//
//  ChatCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

final class ChatCoordinator: ChatCoordinatorProtocol {
    
    var chatViewController: ChatViewController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .chat
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatViewController = ChatViewController()
    }
    
    func start() {
        self.navigationController.pushViewController(self.chatViewController, animated: true)
    }
}

extension ChatCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
