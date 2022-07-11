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
        
        let collectionListener = tokenPath.document(userID)
        
        guard let dictionary = fcmToken.asDictionary else {
            print("[DEBUG] 토큰 데이터 로딩 실패")
            return
        }
        
        collectionListener.setData(dictionary) { error in
            if let error = error {
                print("파이어베이스 저장 에러 \(error.localizedDescription)")
                return
            }
        }
    }
}
