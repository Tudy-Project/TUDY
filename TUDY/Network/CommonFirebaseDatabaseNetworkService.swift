//
//  CommonFirebaseDatabaseNetworkService.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/30.
//

import Foundation
import Firebase
import FirebaseFirestore

final class CommonFirebaseDatabaseNetworkServiceClass {
    
    private var documentListener: ListenerRegistration?

    func save(_ user: User, completion: ((Error?) -> Void)? = nil) {
        
        print("==============WHAT==============")
        let collectionPath = "/USER"
        let collectionListener = Firestore.firestore().collection(collectionPath)
            
            guard let dictionary = user.asDictionary else {
                print("decode error")
                return
            }
        collectionListener.addDocument(data: dictionary) { error in
            completion?(error)
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
