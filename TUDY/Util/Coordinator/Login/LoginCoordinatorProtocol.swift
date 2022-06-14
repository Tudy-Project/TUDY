//
//  LogintCoordinatorProtocol.swift
//  TUDY
//
//  Created by neuli on 2022/05/25.
//

import Foundation

protocol LoginCoordinatorProtocol: Coordinator {
    
    var loginViewController: LoginViewController { get set }
    
    func showLoginViewController()
    func showSetNameViewController()
    func showSetInterestedJobViewController()
    func showSetSubwayViewController()
}
