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
    let heartCount: String
    let imageUrl: String
    let postType: String
    
    init(id: Int, writer: String, title: String, desc: String, heartCount: String, imageUrl: String, postType: String) {
        self.id = id
        self.writer = writer
        self.title = title
        self.desc = desc
        self.heartCount = heartCount
        self.imageUrl = imageUrl
        self.postType = postType
    }
    static var dummyPostList = [
        Post(id:1, writer: "튜디", title: "튜디 프로젝트 창립 멤버 구합니다.", desc: "우리, 여기, 바로, 협업", heartCount: "123", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyEwhcJ2xv6Yl5GrM5huSB7QX2Bs5HAInHllD78ZBjofUM83N5n_hCoMcmdcjE9LmSAe0&usqp=CAU", postType: "project"),
        Post(id:2, writer: "상운", title: "스터디1 구합니다.", desc: "우리, 여기, 바로, 스터디1", heartCount: "21", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyEwhcJ2xv6Yl5GrM5huSB7QX2Bs5HAInHllD78ZBjofUM83N5n_hCoMcmdcjE9LmSAe0&usqp=CAU", postType: "study"),
    Post(id:3, writer: "하늘", title: "스터디2 구합니다.", desc: "우리, 여기, 바로, 스터디2", heartCount: "48", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyEwhcJ2xv6Yl5GrM5huSB7QX2Bs5HAInHllD78ZBjofUM83N5n_hCoMcmdcjE9LmSAe0&usqp=CAU", postType: "study"),
    Post(id:4, writer: "호진", title: "스터디3 구합니다.", desc: "우리, 여기, 바로, 스터디3", heartCount: "12", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyEwhcJ2xv6Yl5GrM5huSB7QX2Bs5HAInHllD78ZBjofUM83N5n_hCoMcmdcjE9LmSAe0&usqp=CAU", postType: "study")
    ]
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
