//
//  TabBarViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/18.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarBackgroundColor()
        let vc1 = TestViewController()
//        let vc2 = ChatViewController()
        vc1.title = "Home"
        
        vc1.navigationItem.largeTitleDisplayMode = .never
        
        let nav1 = UINavigationController(rootViewController: vc1)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav1.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1], animated: false)
        
    }
    
    
    func setTabBarBackgroundColor() {
        tabBar.backgroundColor = .gray
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
    }
    
}
