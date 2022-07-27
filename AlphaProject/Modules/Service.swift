//
//  Service.swift
//  AlphaProject
//
//  Created by a on 2022/7/27.
//

import Foundation
import Moya
import UIKit

enum MyService {
    case dealImage(image: UIImage, type: String)
}

extension MyService: TargetType {
    var baseURL: URL {
        return URL(string: "https://server.tbder.com/")!
    }
    
    var path: String {
        switch self {
        case .dealImage(_, _):
            return "api/v1/openapiadmin/volcengine/jPCartoon"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .dealImage(let image, _):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let str = formatter.string(from: Date())
            let fileName = (str + ".png")
            let imageData = image.jpegData(compressionQuality: 1)!
            let formData = Moya.MultipartFormData.init(provider: .data(imageData),
                                                       name: "file",
                                                       fileName: fileName,
                                                       mimeType: "image/jpeg")
        return .uploadMultipart([formData])
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "multipart/form-data"]
    }
}
