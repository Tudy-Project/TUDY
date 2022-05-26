//
//  LoginCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/25.
//

import UIKit

final class LoginCoordinator: LoginCoordinatorProtocol {
    
    var loginViewController: LoginViewController
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .login
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
        self.loginViewController = LoginViewController()
    }
    
    func start() {
        showLoginViewController()
    }
}

// MARK: - methods
extension LoginCoordinator {
    
    func showLoginViewController() {
        loginViewController.didSendEventClosure = { [weak self] event in
            self?.finish()
        }
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

//MARK: - CoordinatorFinishDelegate
extension LoginCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
