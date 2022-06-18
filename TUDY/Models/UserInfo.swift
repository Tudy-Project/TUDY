//
//  UserInfo.swift
//  TUDY
//
//  Created by jamescode on 2022/06/14.
//

import Foundation

final class UserInfo {
    static let shared = UserInfo()
        
    var user: User?

    //instance생성 방지
    private init() {}
}
