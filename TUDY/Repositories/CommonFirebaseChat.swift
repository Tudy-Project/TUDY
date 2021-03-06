//
//  CommonFirebaseChatData.swift
//  TUDY
//
//  Created by neuli on 2022/06/13.
//

import Foundation

import Firebase
import FirebaseFirestore

struct CommonFirebaseChat {
    
    private static func collectionPath(_ chatState: ChatState) -> String {
        switch chatState {
        case .personalChat:
            return "/PersonalChat"
        case .groupChat:
            return "/GroupChat"
        }
    }
    
    // 자신의 채팅정보 가져오기
    static func fetchPersonalChatInfo(chatState: ChatState, completion: @escaping ([ChatInfo]) -> Void) {
        
        var chatInfos: [ChatInfo] = []
        let collectionPath = collectionPath(chatState)
        let uid = CommonFirebaseUserData.getUserID()
        
        Firestore.firestore()
            .collection(collectionPath)
            .whereField("participantIDs", arrayContains: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: 채팅정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let chatInfo = ChatInfo(dict: dict)
                    chatInfos.append(chatInfo)
                })
                completion(chatInfos)
            }
    }
    
    // 채팅 개설 시 채팅정보 저장 (개인, 단체)
    static func saveChatInfo(_ chatInfo: ChatInfo) {
        
        let collectionPath = collectionPath(chatInfo.chatState)
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        guard let dictionary = chatInfo.asDictionary else {
            print("DEBUG: chat decode error")
            return
        }
        
        collectionListener.addDocument(data: dictionary) { error in
            if let error = error {
                print("DEBUG: 파이어베이스 채팅 저장 오류\(error.localizedDescription)")
                return
            }
        }
    }
    
    static func updateChatInfo() {}
    
    static func deleteChatInfo() {}
}
