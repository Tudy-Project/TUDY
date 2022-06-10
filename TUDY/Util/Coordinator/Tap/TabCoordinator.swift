//
//  TabCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

class TabCoordinator: NSObject, TabCoordinatorProtocol {
    
    var tabBarController: UITabBarController
     
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .tab
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        /// 탭 페이지 정의
        let pages: [TabBarPage] = TabBarPage.allCases
        /// 탭 페이지 각각의 뷰컨 생성
        let controllers: [UINavigationController] = pages.map { getTabController($0) }
        prepareTabBarController(withTabControllers: controllers)
    }
}

// MARK: - TabCoordinatorProtocol
extension TabCoordinator {
    
    func showLogin() {
        let loginCoordinator = LoginCoordinator(navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.loginCoordinatorDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        
        /// UITabBarController를 위한 delegate 설정
        tabBarController.delegate = self
        tabBarController.tabBar.tintColor = .White
        tabBarController.tabBar.backgroundColor = .DarkGray2
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem.init(title: page.pageTitle(),
                                                            image: page.unselecedIcon(),
                                                            selectedImage: page.selecedIcon())
        tabBarController.tabBar.tintColor = .White
        tabBarController.tabBar.unselectedItemTintColor = .White
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController)
            homeCoordinator.finishDelegate = self
            homeCoordinator.homeDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .chat:
            let chatCoordinator = ChatCoordinator(navigationController)
            chatCoordinator.finishDelegate = self
            self.childCoordinators.append(chatCoordinator)
            chatCoordinator.start()
        }
        
        return navigationController
    }
}

// MARK: - HomeCoordinatorDelegate
extension TabCoordinator: HomeCoordinatorDelegate {
    func prepareLoginCoordinator(_ coordinator: HomeCoordinator) {
        self.showLogin()
    }
}

// MARK: - LoginCoordinatorDelegate
extension TabCoordinator: LoginCoordinatorDelegate {
    func showHomeCoordinator() {
        self.childCoordinators.removeAll()
        self.start()
    }
}

// MARK: - CoordinatorFinishDelegate
extension TabCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        
        switch childCoordinator.type {
        case .login:
            navigationController.dismiss(animated: true)
        default: break
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //
    }
}
