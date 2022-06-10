//
//  LoginCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/25.
//

import UIKit

final class LoginCoordinator: LoginCoordinatorProtocol {
    
    var loginViewController: LoginViewController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var loginCoordinatorDelegate: LoginCoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .login
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.navigationBar.tintColor = .black
        self.loginViewController = LoginViewController()
    }
    
    func start() {
        showLoginViewController()
    }
    
    deinit {
        print("Login Coordinator deinit")
    }
}

// MARK: - methods
extension LoginCoordinator {
    
    func showLoginViewController() {
        loginViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.finish()
            case .showSignUp:
                self?.showSetNameViewController()
            }
        }
        loginViewController.modalPresentationStyle = .fullScreen
        navigationController.present(loginViewController, animated: true)
    }
    
    func showSetNameViewController() {
        let setNameViewController = SetNameViewController()
        setNameViewController.didSendEventClosure = { [weak self] event in
            self?.showSetInterestedJobViewController()
        }
        navigationController.pushViewController(setNameViewController, animated: true)
    }
    
    func showSetInterestedJobViewController() {
        let setInterestedJobViewController = SetInterestedJobViewController()
        setInterestedJobViewController.didSendEventClosure = { [weak self] event in
            self?.showSetSubwayViewController()
        }
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.tintColor = .White
        navigationController.pushViewController(setInterestedJobViewController, animated: true)
    }
    
    func showSetSubwayViewController() {
        let setSubwayViewController = SetSubwayViewController()
        setSubwayViewController.didSendEventClosure = { [weak self] event in
            self?.showWelcomeViewController()
        }
        navigationController.pushViewController(setSubwayViewController, animated: true)
    }
    
    func showWelcomeViewController() {
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.didSendEventClosure = { [weak self] event in
            self?.loginCoordinatorDelegate?.showHomeCoordinator()
        }
        
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
}

//MARK: - CoordinatorFinishDelegate
extension LoginCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
