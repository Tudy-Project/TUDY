//
//  HomeCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator {
    
    var homeViewController: HomeViewController { get set }
    
    func pushSearchViewController()
    func pushProjectWriteViewController()
    func pushProjectDetailViewController()
    func showLogin()
}
