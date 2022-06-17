//
//  FirebaseRealtimeChat.swift
//  TUDY
//
//  Created by neuli on 2022/06/15.
//

import Foundation

import Firebase
import FirebaseDatabase

struct FirebaseRealtimeChat {
    
    private static var ref: DatabaseReference = Database.database(url: "https://tudy-b6ce2-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    
    /// 채팅방 ID RealTimeDB에 Chat 추가
    static func saveChat(chatInfoID path: String, message: Message) {
        guard let dict = message.asDictionary else {
            print("DEBUG: chat decode error")
            return
        }
        
        ref.child(path).childByAutoId().updateChildValues(dict)
//        ref.child(path).child(message.messageID).updateChildValues(dict)
    }
    
    /// 채팅방 ID로 Chat 기록 가져오기
    static func fetchChat(chatInfoID path: String, completion: @escaping ([Message]) -> Void) {
        var messages: [Message] = []
        ref.child(path).getData { error, snapshot in
            if let error = error {
                print("DEBUG: 채팅 가져오기 실패 \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            snapshot.forEach { key, value in
                guard let dict = value as? [String: Any] else { return}
                let message = Message(dict: dict)
                messages.append(message)
            }
            completion(messages)
        }
    }
    
    /// 채팅방 ID RealTimeDB에 Chat 메세지 추가될 때마다 호출됨
    static func observe(chatInfoID path: String, completion: @escaping (Message) -> Void) {
        ref.child(path).observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return}
            let message = Message(dict: dict)
            completion(message)
        }
    }
    
    /// 채팅 기록 삭제
    static func removeMessages(chatInfoID path: String) {
        ref.child(path).removeAllObservers()
        ref.child(path).removeValue()
    }
}
