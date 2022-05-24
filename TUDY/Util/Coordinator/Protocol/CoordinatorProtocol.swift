//
//  Coordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    /// 각각의 코디네이터는 하나의 네비게이션 컨트롤러를 가지고 있습니다.
    var navigationController: UINavigationController { get set }
    /// 모든 하위 코디네이터를 가지고 추적하는 배열, 대부분의 경우 이 배열에는 하위 코디네이터가 하나만 포함됩니다.
    var childCoordinators: [Coordinator] { get set }
    /// 코디네이터 타입
    var type: CoordinatorType { get }
    
    init(_ navigationController: UINavigationController)
    
    func start()
    func finish()
}

extension Coordinator {
    
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
