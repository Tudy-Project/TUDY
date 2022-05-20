//
//  Post.swift
//  TUDY
//
//  Created by jamescode on 2022/05/20.
//

import Foundation


struct Post: Codable, Hashable {
    let id: Int
    var identifier = UUID()
    let writer: String
    let title: String
    let desc: String
    let imageLink: String
    let postType: String
    
    init(id: Int, writer: String, title: String, desc: String, imageLink: String, postType: String) {
        self.id = id
        self.writer = writer
        self.title = title
        self.desc = desc
        self.imageLink = imageLink
        self.postType = postType
    }
    static var dummyPostList = [Post(id:1, writer: "튜디", title: "튜디 프로젝트 창립 멤버 구합니다.", desc: "우리, 여기, 바로, 협업", imageLink: "", postType: "project")]
}


//struct Post: Codable, Hashable {
//    let name, latinName, animalType, activeTime: String
//    let lengthMin, lengthMax, weightMin, weightMax: String
//    let lifespan, habitat, diet, geoRange: String
//    let imageLink: String
//    let id: Int
//    let identifier = UUID()
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case latinName = "latin_name"
//        case animalType = "animal_type"
//        case activeTime = "active_time"
//        case lengthMin = "length_min"
//        case lengthMax = "length_max"
//        case weightMin = "weight_min"
//        case weightMax = "weight_max"
//        case lifespan, habitat, diet
//        case geoRange = "geo_range"
//        case imageLink = "image_link"
//        case id
//    }
//}
