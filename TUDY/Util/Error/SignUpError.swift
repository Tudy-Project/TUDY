//
//  SignUpError.swift
//  TUDY
//
//  Created by neuli on 2022/05/23.
//

import Foundation

enum SignUpError: Error {
    
    case nicknameDuplicatedError
    
    var errorDescription: String? {
        switch self {
        case .nicknameDuplicatedError:
            return "이미 존재하는 닉네임입니다."
        }
    }
}
