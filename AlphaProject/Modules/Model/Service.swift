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
    case cartoonImage(image: UIImage)
    case pixarImage(image: UIImage, type: String)
    case gameImage(image: UIImage)
}

extension MyService: TargetType {
    var baseURL: URL {
        return URL(string: "https://server.tbder.com/")!
    }
    
    var path: String {
        switch self {
        case .cartoonImage(_):
            return "api/v1/openapiadmin/volcengine/jPCartoon"
        case .gameImage(_):
            return "api/v1/openapiadmin/volcengine/gameCartoon3D"
        case .pixarImage(_, _):
            return "api/v1/openapiadmin/volcengine/potraitEffect"
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
        case .cartoonImage(let image):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let str = formatter.string(from: Date())
            let fileName = (str + ".png")
            let imageData = image.jpegData(compressionQuality: 1)!
            let formData = Moya.MultipartFormData.init(provider: .data(imageData),
                                                       name: "file",
                                                       fileName: fileName,
                                                       mimeType: "image/jpeg")
            return .uploadCompositeMultipart([formData], urlParameters: ["cartoon_type": "classic_cartoon"])
        case .gameImage(let image):
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
        case .pixarImage(image: let image, type: let type):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let str = formatter.string(from: Date())
            let fileName = (str + ".png")
            let imageData = image.jpegData(compressionQuality: 1)!
            let formData = Moya.MultipartFormData.init(provider: .data(imageData),
                                                       name: "file",
                                                       fileName: fileName,
                                                       mimeType: "image/jpeg")
            return .uploadCompositeMultipart([formData], urlParameters: ["type": type])
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "multipart/form-data"]
    }
}
