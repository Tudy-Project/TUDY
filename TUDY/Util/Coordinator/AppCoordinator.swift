//
//  AppCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

/// AppCoordinator 는 앱의 life cycle동안 유일하게 존재하는 하나의 코디네이터 입니다.
class AppCoordinator: AppCoordinatorProtocol {
    
    /// 부모와 자식 관계 간에 순환 참조가 일어날 수 있으므로 weak로 선언
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .app
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        showMainFlow()
    }
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        
        switch childCoordinator.type {
        case .tab:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        default:
            break
        }
    }
}
