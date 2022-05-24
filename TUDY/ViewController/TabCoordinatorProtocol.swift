//
//  TabCoordinatorProtocol.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    
    var tabBarController: UITabBarController { get set }

    func currentPage() -> TabBarPage?
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
}
