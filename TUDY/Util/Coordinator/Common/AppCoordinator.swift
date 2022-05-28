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
    
    /// 생성자에서 할당받을 네비게이션 컨트롤러
    var navigationController: UINavigationController
    
    /// 하위 coordinator
    var childCoordinators: [Coordinator] = []
    
    /// coordinator 타입 (구조 그림 참조)
    var type: CoordinatorType = .app
    
    /// 생성자 - 네비게이션 할당
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        showMainFlow()
    }
}

// MARK: - AppCoordinatorProtocol Methods
extension AppCoordinator {
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

// MARK: - CoordinatorFinishDelegate
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
