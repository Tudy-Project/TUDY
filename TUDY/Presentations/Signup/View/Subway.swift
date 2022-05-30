//
//  Subway.swift
//  TUDY
//
//  Created by neuli on 2022/05/30.
//

import UIKit

struct Subway: Hashable {
    var station: String
    var icons: [UIImage] = []
    
    init(station: String, iconNames: String...) {
        self.station = station
        for iconName in iconNames {
            if let image = UIImage(systemName: iconName) {
                self.icons.append(image)
            }
        }
    }
    
    static let data = [
        Subway(station: "서울역", iconNames: "circle"),
        Subway(station: "서울", iconNames: "circle"),
        Subway(station: "서현", iconNames: "circle"),
        Subway(station: "서대문", iconNames: "circle"),
    ]
}
