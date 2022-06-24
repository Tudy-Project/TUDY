//
//  CommonFirebaseUserData.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseUser {
    
    private static let userPath = Firestore.firestore().collection("USER")
    
    /// 자신의 UserID 가져오기
    static func getUserID() -> String {
        guard let userID = Auth.auth().currentUser?.uid else {
//            fatalError("[DEBUG] 파이어베이스 유저 데이터 로딩 실패")
            return ""
        }
        return userID
    }
    
    /// 회원가입 시 새로운 유저 저장
    static func saveUserData(_ user: User, completion: ((Error?) -> Void)? = nil) {
        
        var user = user
        user.userID = getUserID()
        user.signUpDate = Date().description
        
        let collectionListener = userPath.document(user.userID)
        
        guard let dictionary = user.asDictionary else {
            print("[DEBUG] 파이어베이스 유저 데이터 로딩 실패")
            return
        }
        collectionListener.setData(dictionary) { error in
            if let error = error {
                print("파이어베이스 저장 에러 \(error.localizedDescription)")
                return
            }
            updateUserID()
        }
    }
    
    /// 회원가입 후 유저ID 업데이트
    private static func updateUserID() {
        let userID = getUserID()
        userPath.document(userID).updateData(["userID" : userID])
    }
    
    /// 모든 유저 정보 가져오기
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users: [User] = []
        userPath.getDocuments { snapshot, error in
            if let error = error {
                print("[DEBUG] 유저정보 가져오기 실패 \(error.localizedDescription)")
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
    
    /// 자신의 유저 정보 가져오기
    static func fetchUser(completion: @escaping (User) -> Void) {
        let userID = getUserID()
        
        userPath
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("[DEBUG] 유저정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let user = User(dict: dict)
                    completion(user)
                })
            }
        
        // addUserSnapshotListener()
    }
    
    /// 다른 사람의 유저 정보 가져오기
    static func fetchOtherUser(userID: String, completion: @escaping (User) -> Void) {
        userPath
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("[DEBUG] 유저정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let user = User(dict: dict)
                    completion(user)
                })
            }
    }
    
    /// 자신의 User정보가 업데이트 되면 호출되는 함수
    static func addUserSnapshotListener() {
        let userID = getUserID()
        
        userPath
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("[DUBUG] 유저정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documentChanges.forEach({ change in
                        let dict = change.document.data()
                        let user = User(dict: dict)
                        UserInfo.shared.user = user
                })
            }
    }
}

