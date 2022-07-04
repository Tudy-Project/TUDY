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
            case .showFastSearch(let work):
                self?.pushFastSearchViewController(work: work)
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
            case .showLogin:
                self?.showLogin()
            case .showModifyProject(let project):
                self?.showModifyProject(project: project)
            case .showDeClaration:
                // 신고하기 화면?
                break
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
            case .updateProject(let viewController):
                self?.updateProject(viewController: viewController)
            }
        }
        
        self.navigationController.present(projectWriteNavigationController, animated: true)
    }
    
    func registerProject(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
    
    func updateProject(viewController: UIViewController) {
        viewController.dismiss(animated: true)
        navigationController.popViewController(animated: true)
    }
    
    func showLogin() {
        self.loginDelegate?.prepareLoginCoordinator()
    }
    
    func showModifyProject(project: Project) {
        let projectWriteViewController = ProjectWriteViewController()
        let projectWriteNavigationController = UINavigationController(rootViewController: projectWriteViewController)
        projectWriteViewController.navAppear()
        projectWriteNavigationController.modalPresentationStyle = .fullScreen
        
        projectWriteViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .registerProject(let viewController):
                self?.registerProject(viewController: viewController)
            case .updateProject(let viewController):
                self?.updateProject(viewController: viewController)
            }
        }
        projectWriteViewController.project = project
        self.navigationController.present(projectWriteNavigationController, animated: true)
    }
    
    func pushFastSearchViewController(work: String) {
        let fastSearchViewController = FastSearchViewController()
        fastSearchViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .showProjectDetail(let project):
                self?.pushProjectDetailViewController(project: project)
            }
        }
        fastSearchViewController.work = work
        navigationController.pushViewController(fastSearchViewController, animated: true)
    }
}

//MARK: - CoordinatorFinishDelegate
extension HomeCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
