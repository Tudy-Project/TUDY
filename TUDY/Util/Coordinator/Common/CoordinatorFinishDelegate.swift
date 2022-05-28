//
//  CoordinatorFinishDelegate.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

/// 부모 코디네이터가 자식이 finish 됐을 때 알 수 있도록 돕는 delegate 프로토콜
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
