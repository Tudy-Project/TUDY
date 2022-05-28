//
//  LoginCheckProtocol.swift
//  TUDY
//
//  Created by neuli on 2022/05/19.
//

import UIKit
import Firebase

protocol LoginCheck {
    
    func isLogin() -> Bool
}

extension LoginCheck {
    
    func isLogin() -> Bool {
        print(Auth.auth().currentUser?.uid != nil ? "DEBUG: 로그인 되어있음" : "DEBUG: 로그인 안되어있음")
        return Auth.auth().currentUser?.uid != nil ? true : false
    }
}
