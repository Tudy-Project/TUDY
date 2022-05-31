//
//  NetworkError.swift
//  TUDY
//
//  Created by neuli on 2022/05/31.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transportError
    case serverError
    case missinfDataError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "존재하지 않는 URL 입니다."
        case .transportError:
            return "TransportError가 발생하였습니다."
        case .serverError:
            return "서버에러 입니다."
        case .missinfDataError:
            return "데이터가 유실되었습니다."
        case .decodingError:
            return "디코딩에 실패하였습니다."
        }
    }
}
