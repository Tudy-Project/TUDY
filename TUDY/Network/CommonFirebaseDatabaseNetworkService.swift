//
//  CommonFirebaseDatabaseNetworkService.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation
import Firebase
import FirebaseFirestore

struct CommonFirebaseDatabaseNetworkService {
    
    private var documentListener: ListenerRegistration?
    
    static func getUserID() -> String {
        guard let userID = Auth.auth().currentUser?.uid else { fatalError() }
        return userID
    }
    
    static func save(_ user: User, completion: ((Error?) -> Void)? = nil) {
        
        var user = user
        user.userID = getUserID()
        user.signUpDate = Date().description
        
        let collectionPath = "/USER"
        let collectionListener = Firestore.firestore().collection(collectionPath).document(user.userID)
        
        guard let dictionary = user.asDictionary else {
            print("decode error")
            return
        }
        collectionListener.setData(dictionary) { error in
            if let error = error {
                print("파이어베이스 저장 에러 \(error.localizedDescription)")
            }
        }
//        collectionListener.addDocument(data: dictionary) { error in
//            completion?(error)
//        }
    }
    
    static func fetchUser(completion: @escaping([User]) -> Void) {
        var users: [User] = []
        Firestore.firestore().collection("USER").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: 유저정보 가져오기 실패 \(error.localizedDescription)")
                return
            }
            snapshot?.documents.forEach({ document in
                let dict = document.data()
                let user = User(dict: dict)
                users.append(user)
            })
            completion(users)
        }
    }
}



//class CommonFirebaseDatabaseNetworkService {
//    private let databaseReference: DatabaseReference = Database.database().reference()
//
//
//
//
//
//
//}
