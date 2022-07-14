//
//  FirestoreChat.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/29.
//

import Foundation


import Firebase
import FirebaseFirestore
import UIKit

struct FirestoreChat {
    
    /// 채팅보낼 시, 채팅 메세지 저장 (개인, 단체)
    /// Collection(MESSAGE) -> document(chatInfo) -> Collection(Message에 대한 UUID) -> dcument(메세지 보낸 시간) -> DATA
    static func saveChat(chatInfo: ChatInfo, message: Message) {
        
        let collectionListener = Firestore.firestore().collection("Message")
        
        guard let dictionary = message.asDictionary else {
            print("DEBUG: chat decode error")
            return
        }
        
        collectionListener.document(chatInfo.chatInfoID).collection(chatInfo.chatInfoID).document(message.createdDate).setData(dictionary) { error in
            if let error = error {
                print("DEBUG: 파이어베이스 채팅 저장 오류\(error.localizedDescription)")
                return
            }
        }
    }

    // 채팅메세지 가져오기
    static func fetchChat(chatInfo: ChatInfo, completion: @escaping ([Message]) -> Void) {
        
        var messages : [Message] = []
        
        let messageRef = Firestore.firestore().collection("Message").document(chatInfo.chatInfoID).collection(chatInfo.chatInfoID)
        
        messageRef.getDocuments { snapshot, error in

            if let error = error {
                print("DEBUG: 채팅 메세지 가져오기 실패 \(error.localizedDescription)")
                return
            }
            snapshot?.documents.forEach({ document in
                let dict = document.data()
                let message = Message(dict: dict)
                messages.append(message)
            })
            completion(messages)
        }
    }
    
    /// 채팅메시지 observe하기
    static func observeChat(chatInfo: ChatInfo, completion: @escaping ([Message]) -> Void) {
        print(#function)

        let messageRef = Firestore.firestore().collection("Message").document(chatInfo.chatInfoID).collection(chatInfo.chatInfoID)
        
        messageRef.addSnapshotListener { snapshot, error in
            print("============================================================THIS IS OBSERVECHAT!============================================================")
            var messages : [Message] = []
            if let error = error {
                print("DEBUG: 채팅 메세지 가져오기 실패 \(error.localizedDescription)")
                return
            }
            snapshot?.documents.forEach({ document in
                let dict = document.data()
                let message = Message(dict: dict)
                messages.append(message)
            })
            completion(messages)
        }
    }
    
    
//            .whereField("participantIDs", arrayContains: uid)
//            .addSnapshotListener({ snapshot, error in
//                if let error = error {
//                    print("DEBUG: 채팅정보 가져오기 실패 \(error.localizedDescription)")
//                    return
//                }
//                var chatInfos: [ChatInfo] = []
//                snapshot?.documents.forEach({ document in
//                    let dict = document.data()
//                    let chatInfo = ChatInfo(dict: dict)
//                    chatInfos.append(chatInfo)
//                })
//                chatInfos.sort { $0.latestMessageDate > $1.latestMessageDate }
//                completion(chatInfos)
//            })

    
    
//    static func fetchChat(chatInfoID path: String, completion: @escaping ([Message]) -> Void) {
//        var messages: [Message] = []
//        ref.child(path).getData { error, snapshot in
//            if let error = error {
//                print("DEBUG: 채팅 가져오기 실패 \(error.localizedDescription)")
//                return
//            }
//            guard let snapshot = snapshot.value as? [String: Any] else { return }
//            snapshot.forEach { key, value in
//                guard let dict = value as? [String: Any] else { return}
//                let message = Message(dict: dict)
//                messages.append(message)
//            }
//            completion(messages)
//        }
//    }
//    static func collectionPath(_ chatState: ChatState) -> String {
//        switch chatState {
//        case .personalChat:
//            return "/PersonalChat"
//        case .groupChat:
//            return "/GroupChat"
//        }
//    }
    

    

    
//    static func leaveChat(chatInfo: ChatInfo) {
//        let userID = FirebaseUser.getUserID()
//        let collectionPath = collectionPath(chatInfo.chatState)
//        let collectionListener = Firestore.firestore().collection(collectionPath)
//
//        let participantIDs = chatInfo.participantIDs.filter { $0 != userID }
//
//        if participantIDs.isEmpty {
//            collectionListener.document(chatInfo.chatInfoID)
//                .delete()
//            // 채팅기록 삭제
//            FirebaseRealtimeChat.removeMessages(chatInfoID: chatInfo.chatInfoID)
//        } else {
//            if chatInfo.projectMasterID == userID {
//                collectionListener.document(chatInfo.chatInfoID)
//                    .updateData(["projectMasterID" : participantIDs[0]])
//            }
//            collectionListener.document(chatInfo.chatInfoID)
//                .updateData(["participantIDs" : participantIDs])
//        }
//    }
}
