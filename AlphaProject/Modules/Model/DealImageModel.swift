//
//  DealImageModel.swift
//  AlphaProject
//
//  Created by a on 2022/7/28.
//

import Foundation
import ObjectMapper

class DealImageModel: Mappable {
    var code: Int?
    var message: String?
    var status: Int?
    var image: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["code"]
        image <- map["data.image"]
        message <- map["message"]
        status <- map["status"]
    }
}
