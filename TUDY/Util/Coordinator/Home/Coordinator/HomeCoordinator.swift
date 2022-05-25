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
            }
        }
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func pushSearchViewController() {
        let searchViewController = SearchViewController()
        self.navigationController.pushViewController(searchViewController, animated: true)
    }
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
