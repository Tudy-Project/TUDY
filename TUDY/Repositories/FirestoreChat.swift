//
//  FirestoreChat.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/29.
//

import Foundation


import Firebase
import FirebaseFirestore

struct FirestoreChat {
    
    // 채팅보낼 시, 채팅 메세지 저장 (개인, 단체)
    static func saveChat(_ chatInfo: ChatInfo, message: Message) {
        
        let collectionListener = Firestore.firestore().collection("Message")
        
        guard let dict = message.asDictionary else {
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
    
    static func saveChat(chatInfoID path: String, message: Message) {
        guard let dict = message.asDictionary else {
            print("DEBUG: chat decode error")
            return
        }
        
        ref.child(path).childByAutoId().updateChildValues(dict)
//        ref.child(path).child(message.messageID).updateChildValues(dict)
    }
    
    
    
//    static func collectionPath(_ chatState: ChatState) -> String {
//        switch chatState {
//        case .personalChat:
//            return "/PersonalChat"
//        case .groupChat:
//            return "/GroupChat"
//        }
//    }
    
    // 자신의 채팅정보 가져오기
//    static func fetchChatInfo(chatState: ChatState, completion: @escaping ([ChatInfo]) -> Void) {
//        let collectionPath = collectionPath(chatState)
//        let uid = FirebaseUser.getUserID()
//
//        Firestore.firestore()
//            .collection(collectionPath)
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
