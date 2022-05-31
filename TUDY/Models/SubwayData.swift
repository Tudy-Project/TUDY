//
//  SubwayData.swift
//  TUDY
//
//  Created by neuli on 2022/05/30.
//

import Foundation

struct SubwayResult: Codable {
    let SearchSTNBySubwayLineInfo: SearchSTNBySubwayLineInfo
}

struct SearchSTNBySubwayLineInfo: Codable {
    let row: [SubwayData]
}

// api로 담아올 수 있는 지하철 역 정보
struct SubwayData: Codable {
    let station: String
    let line: String
    
    enum CodingKeys: String, CodingKey {
        case station = "STATION_NM"
        case line = "LINE_NUM"
    }
}
