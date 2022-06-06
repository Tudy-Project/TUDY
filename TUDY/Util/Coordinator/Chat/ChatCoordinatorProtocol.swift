//
//  ChatCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import Foundation

protocol ChatCoordinatorProtocol: Coordinator {
    
    var chatListViewController: ChatListViewController { get set }
    
    func showPersonalChat(_ chatPartners: [String])
    func showGroupChat(_ chatPartners: [String])
}
