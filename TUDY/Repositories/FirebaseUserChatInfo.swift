//
//  FirebaseUserChatInfo.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

import Firebase
import FirebaseFirestore

struct FirebaseUserChatInfo {
    
    private static let userChatInfoPath = Firestore.firestore().collection("UserChatInfo")
    private static let chatInfoPath = "ChatInfo"
    
    /// 채팅방 첫 개설시 유저 채팅방 정보 업데이트
    static func updateUserChatInfoID(chatInfo: ChatInfo) {
        for userID in chatInfo.participantIDs {
            
            let userChatInfo = UserChatInfo(chatInfoID: chatInfo.chatInfoID)
            guard let dictionary = userChatInfo.asDictionary else {
                print("[DEBUG] 파이어베이스 유저 채팅정보 인코딩 실패")
                return
            }
            userChatInfoPath
                .document(userID)
                .collection(chatInfoPath)
                .document(chatInfo.chatInfoID)
                .setData(dictionary)
        }
    }
    
    /// 채팅방 정보 전체 가져오기
    static func fetchUserChatInfos(completion: @escaping([UserChatInfo]) -> Void) {
        let userID = FirebaseUser.getUserID()
        var userChatInfos: [UserChatInfo] = []
        userChatInfoPath
            .document(userID)
            .collection(chatInfoPath)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("[DEBUG] 유저채팅정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let userChatInfo = UserChatInfo(dict: dict)
                    userChatInfos.append(userChatInfo)
                })
                completion(userChatInfos)
            }
    }
    
    /// 채팅방 정보 가져오기 : 유저ID, 채팅방 ID로
    static func fetchUserChatInfo(chatInfoID: String, completion: @escaping(UserChatInfo) -> Void) {
        let userID = FirebaseUser.getUserID()
        userChatInfoPath
            .document(userID)
            .collection(chatInfoPath)
            .document(chatInfoID)
            .getDocument { snapshot, error in
                if let error = error {
                    print("[DEBUG] 유저채팅정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                guard let dict = snapshot?.data() else { return }
                let userChatInfo = UserChatInfo(dict: dict)
                completion(userChatInfo)
            }
    }
    
    /// 채팅방 알림 설정 업데이트
    static func updateNotification(chatInfoID: String, chatNotification: Bool, completion: @escaping() -> Void) {
        let userID = FirebaseUser.getUserID()
        userChatInfoPath
            .document(userID)
            .collection(chatInfoPath)
            .document(chatInfoID)
            .updateData(["chatNotification" : chatNotification])
        completion()
    }
    
    /// 채팅방 즐겨찾기 설정 업데이트
    static func updateBookMark(chatInfoID: String, bookMark: Bool, completion: @escaping() -> Void) {
        let userID = FirebaseUser.getUserID()
        userChatInfoPath
            .document(userID)
            .collection(chatInfoPath)
            .document(chatInfoID)
            .updateData(["bookMark" : bookMark])
        completion()
    }
    
    static func deleteUserChatInfo(at chatInfoID: String) {
        let userID = FirebaseUser.getUserID()
        userChatInfoPath
            .document(userID)
            .collection(chatInfoPath)
            .document(chatInfoID)
            .delete()
    }
}
