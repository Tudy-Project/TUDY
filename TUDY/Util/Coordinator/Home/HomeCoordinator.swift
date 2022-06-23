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
    weak var loginDelegate: LoginCheckDelegate?
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
                self?.showProjectWriteViewController()
            case .showProjectDetail(let project):
                self?.pushProjectDetailViewController(project: project)
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
    
    func pushProjectDetailViewController(project: Project) {
        let projectDetailViewController = ProjectDetailViewController()
        projectDetailViewController.project = project
        projectDetailViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .showPersonalChat(let user):
                self?.homeDelegate?.showPersonalChat(with: user)
            }
        }
        self.navigationController.pushViewController(projectDetailViewController, animated: true)
    }
    
    func showProjectWriteViewController() {
        let projectWriteViewController = ProjectWriteViewController()
        let projectWriteNavigationController = UINavigationController(rootViewController: projectWriteViewController)
        projectWriteViewController.navAppear()
        projectWriteNavigationController.modalPresentationStyle = .fullScreen
       
        projectWriteViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .registerProject(let viewController):
                self?.registerProject(viewController: viewController)
            }
        }
        
        self.navigationController.present(projectWriteNavigationController, animated: true)
    }
    
    func registerProject(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
    
    func showLogin() {
        self.loginDelegate?.prepareLoginCoordinator()
    }
}

//MARK: - CoordinatorFinishDelegate
extension HomeCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
