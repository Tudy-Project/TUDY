//
//  TabCoordinatorProtocol.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    
    /// ViewController 선언
    var tabBarController: UITabBarController { get set }
    
    func showLogin()

    func currentPage() -> TabBarPage?
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
}
