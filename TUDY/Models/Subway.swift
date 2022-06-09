//
//  Subway.swift
//  TUDY
//
//  Created by neuli on 2022/05/30.
//

import UIKit

// SubwayData를 가공하여 하나의 역에 여러 호선을 담을 수 있는 Subway 구조체
struct Subway: Hashable {
    var station: String = ""
    var lines: [String] = []
}
