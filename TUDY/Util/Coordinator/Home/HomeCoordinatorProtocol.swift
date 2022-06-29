//
//  HomeCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import Foundation
import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    
    var homeViewController: HomeViewController { get set }
    
    func pushSearchViewController()
    func showProjectWriteViewController()
    func registerProject(viewController: UIViewController)
    func updateProject(viewController: UIViewController)
    func pushProjectDetailViewController(project: Project)
    func showLogin()
    func showModifyProject(project: Project)
}
