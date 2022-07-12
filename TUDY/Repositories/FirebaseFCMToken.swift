//
//  FirebaseToken.swift
//  TUDY
//
//  Created by neuli on 2022/07/11.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseFCMToken {
    
    private static let tokenPath = Firestore.firestore().collection("TOKEN")
    
    /// FCM 토큰 저장
    static func saveFCMToken(token: String) {
        
        let userID = FirebaseUser.getUserID()
        let fcmToken = FCMToken(userID: userID, fcmToken: token)
        
        let path = tokenPath.document(userID)
        
        guard let dictionary = fcmToken.asDictionary else {
            print("[DEBUG] 토큰 데이터 로딩 실패")
            return
        }
        
        path.setData(dictionary) { error in
            if let error = error {
                print("파이어베이스 저장 에러 \(error.localizedDescription)")
                return
            }
        }
    }
    
    static func fetchFCMToken(userID: String, completion: @escaping (String) -> Void) {
        
        tokenPath
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("[DEBUG] 유저정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let fcmToken = FCMToken(dict: dict)
                    completion(fcmToken.fcmToken)
                })
            }
    }
}
