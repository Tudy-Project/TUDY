//
//  ChatCoordinator.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import Foundation

protocol ChatCoordinatorProtocol: Coordinator {
    
    var chatListViewController: ChatListViewController { get set }
    var chatViewController: ChatProtocol? { get set }
    
    func pushChatViewController(chatInfo: ChatInfo)
    func makePersonalChatViewController(with projectWriter: User)
    func moveGroupChatViewController(chatInfo: ChatInfo)
    func pushNotificationChatViewController(chatInfoID: String)
}
