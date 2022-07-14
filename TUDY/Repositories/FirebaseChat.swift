//
//  CommonFirebaseChatData.swift
//  TUDY
//
//  Created by neuli on 2022/06/13.
//

import Foundation

import Firebase
import FirebaseFirestore

struct FirebaseChat {
    
    static func collectionPath(_ chatState: ChatState) -> String {
        switch chatState {
        case .personalChat:
            return "/PersonalChat"
        case .groupChat:
            return "/GroupChat"
        }
    }
    
    // chatInfoID로 채팅정보 가져오기
    static func fetchChatInfoByChatInfoID(chatInfoID: String, completion: @escaping (ChatInfo) -> Void) {
        var savedChatInfo: ChatInfo?
        let uid = FirebaseUser.getUserID()
        let groupChatCollectionPath = collectionPath(.groupChat)
        let personalChatCollectionPaht = collectionPath(.personalChat)
        
        Firestore.firestore()
            .collection(groupChatCollectionPath)
            .whereField("participantIDs", arrayContains: uid)
            .whereField("chatInfoID", isEqualTo: chatInfoID)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    print("DEBUG: 채팅정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let chatInfo = ChatInfo(dict: dict)
                    savedChatInfo = chatInfo
                    completion(chatInfo)
                    return
                })
            })
        
        if let _ = savedChatInfo {
            return
        }

        
        Firestore.firestore()
            .collection(personalChatCollectionPaht)
            .whereField("participantIDs", arrayContains: uid)
            .whereField("chatInfoID", isEqualTo: chatInfoID)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    print("DEBUG: 채팅정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let chatInfo = ChatInfo(dict: dict)
                    completion(chatInfo)
                    return
                })
            })
    }
    
    // 자신의 채팅정보 가져오기
    static func fetchChatInfo(chatState: ChatState, completion: @escaping ([ChatInfo]) -> Void) {
        let collectionPath = collectionPath(chatState)
        let uid = FirebaseUser.getUserID()
        
        Firestore.firestore()
            .collection(collectionPath)
            .whereField("participantIDs", arrayContains: uid)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    print("DEBUG: 채팅정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                var chatInfos: [ChatInfo] = []
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let chatInfo = ChatInfo(dict: dict)
                    chatInfos.append(chatInfo)
                })
                chatInfos.sort { $0.latestMessageDate > $1.latestMessageDate }
                completion(chatInfos)
            })
    }
    
    // 채팅 개설 시 채팅정보 저장 (개인, 단체)
    static func saveChatInfo(_ chatInfo: ChatInfo, completion: (() -> Void)? = nil) {
        
        let collectionPath = collectionPath(chatInfo.chatState)
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        guard let dictionary = chatInfo.asDictionary else {
            print("DEBUG: chat decode error")
            return
        }
        
        collectionListener.document(chatInfo.chatInfoID).setData(dictionary) { error in
            if let error = error {
                print("DEBUG: 파이어베이스 채팅 저장 오류\(error.localizedDescription)")
                return
            }
            if let completion = completion {
                completion()
            }
        }
        
        // 채팅 개설 후 참여자 유저 정보에 채팅 정보 추가
        FirebaseUserChatInfo.updateUserChatInfoID(chatInfo: chatInfo)
    }
    
    static func leaveChat(chatInfo: ChatInfo) {
        let userID = FirebaseUser.getUserID()
        let collectionPath = collectionPath(chatInfo.chatState)
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        let participantIDs = chatInfo.participantIDs.filter { $0 != userID }
        
        if participantIDs.isEmpty {
            collectionListener.document(chatInfo.chatInfoID)
                .delete()
            // 채팅기록 삭제
            FirebaseRealtimeChat.removeMessages(chatInfoID: chatInfo.chatInfoID)
        } else {
            if chatInfo.projectMasterID == userID {
                collectionListener.document(chatInfo.chatInfoID)
                    .updateData(["projectMasterID" : participantIDs[0]])
            }
            collectionListener.document(chatInfo.chatInfoID)
                .updateData(["participantIDs" : participantIDs])
        }
    }
}
