//
//  HomeCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

final class HomeCoordinator: HomeCoordinatorProtocol {
    
    var homeViewController: HomeViewController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var homeDelegate: HomeCoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .home
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        homeViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .showSearch:
                self?.pushSearchViewController()
            case .showProjectWrite:
                self?.pushProjectWriteViewController()
            case .showLogin:
                self?.showLogin()
            }
        }
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    deinit {
        print("Home Coordinaotr deinit")
    }
}

// MARK: - HomeCoordinatorProtocol
extension HomeCoordinator {
    
    func pushSearchViewController() {
        let searchViewController = SearchViewController()
        self.navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func pushProjectWriteViewController() {
        let projectWriteViewController =
        ProjectWriteViewController()
        self.navigationController
            .pushViewController(projectWriteViewController, animated: true)
//        navigationController.navigationBar.backItem?.backButtonTitle = ""
    }
    
    func showLogin() {
        self.prepareLoginCoordinator(self)
    }
}

// MARK: - HomeCoordinatorDelegate
extension HomeCoordinator: HomeCoordinatorDelegate {
    func prepareLoginCoordinator(_ coordinator: HomeCoordinator) {
        self.homeDelegate?.prepareLoginCoordinator(self)
    }
}

//MARK: - CoordinatorFinishDelegate
extension HomeCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
