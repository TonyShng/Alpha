//
//  NetworkManager.swift
//  AlphaProject
//
//  Created by a on 2022/7/28.
//

import Foundation
import Alamofire
import Moya
import ObjectMapper
import SwiftyJSON
import SystemConfiguration
import SwiftyUserDefaults
import SwiftUI

// 超时时长
private var requestTimeOut: Double = 30
// 单个模型的成功回调
typealias RequestModelSuccessCallback<T: Mappable> = ((T, ResponseModel) -> Void)
// 数组模型的成功回调
typealias RequestModelsSuccessCallback<T: Mappable> = (([T], ResponseModel) -> Void)
// 网络请求的回调
typealias RequestCallback = ((ResponseModel) -> Void)
// 网络错误的回调
typealias RequestErrorCallback = (() -> Void)

/// dataKey一般是 "data"  这里用的知乎daily 的接口 为stories
let responseDataKey = "data"
let responseMessageKey = "message"
let responseCodeKey = "status"
let successCode: Int = 20000

private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    var endpoint = Endpoint(url: url,
                            sampleResponseClosure: { .networkResponse(20000, target.sampleData) },
                            method: target.method,
                            task: task,
                            httpHeaderFields: target.headers)
    requestTimeOut = 30
    
    return endpoint
}

// 网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = requestTimeOut
        if let requestData = request.httpBody {
            log.debug("请求的url：\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "发送参数" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            log.debug("请求的url：\(request.url!)" + "\(String(describing: request.httpMethod))")
        }
        
        if let header = request.allHTTPHeaderFields {
            log.debug("请求头内容\(header)")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
    log.debug("networkPlugin \(changeType)")
    switch changeType {
    case .began:
        ProgressHUD.show(nil, interaction: false)
    case .ended:
        log.debug("结束")
    }
}

private let provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

@discardableResult
/// 网络请求，结果为单个模型
/// - Parameters:
///   - target: 接口
///   - needShowFailAlert: 是否显示失败弹窗
///   - modelType: 模型
///   - successCallback: 成功回调
///   - failureCallback: 失败回调
/// - Returns: 取消当前网络请求 Cancellable 实例
func networkRequest<T: Mappable>(_ target: TargetType,
                                 needShowFailAlert: Bool = true,
                                 modelType: T.Type,
                                 successCallback:@escaping RequestModelSuccessCallback<T>,
                                 failureCallback: RequestCallback? = nil) -> Cancellable? {
    return networkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { responseModel in
        if let model = T(JSONString: responseModel.data) {
            successCallback(model, responseModel)
        } else {
            errorHandler(code: responseModel.status, message: "Parse failure", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }, failureCallback: failureCallback)
}

@discardableResult
/// 网络请求，结果为模型数组
/// - Parameters:
///   - target: 接口
///   - needShowFailAlert: 是否显示失败弹窗
///   - modelType: 模型
///   - successCallback: 成功回调
///   - failureCallback: 失败回调
/// - Returns: 取消当前网络请求 Cancellable 实例
func networkRequest<T: Mappable>(_ target: TargetType,
                                 needShowFailAlert: Bool = true,
                                 modelType: [T].Type,
                                 successCallback:@escaping RequestModelsSuccessCallback<T>,
                                 failureCallback: RequestCallback? = nil) -> Cancellable? {
    return networkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { responseModel in
        if let model = [T](JSONString: responseModel.data) {
            successCallback(model, responseModel)
        } else {
            errorHandler(code: responseModel.status, message: "Parse failure", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }, failureCallback: failureCallback)
}

@discardableResult
/// 网络请求基础方法
/// - Parameters:
///   - target: 接口
///   - needShowFailAlert: 是否显示失败弹窗
///   - successCallback: 成功回调
///   - failureCallback: 失败回调
/// - Returns: 取消当前网络请求 Cancellable 实例
func networkRequest(_ target: TargetType,
                    needShowFailAlert: Bool = true,
                    successCallback:@escaping RequestCallback,
                    failureCallback: RequestCallback? = nil) -> Cancellable? {
    if !UIDevice.isNetworkConnect {
        errorHandler(code: 9999, message: "There seems to be a problem with the network", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        return nil
    }
    return provider.request(MultiTarget(target)) { result in
        switch result {
        case let .success(response):
            do {
                let jsonData = try JSON(data: response.data)
                log.debug("返回结果是: \(jsonData)")
                if !validateResponse(response: jsonData.dictionary, needShowFailAlert: needShowFailAlert, failure: failureCallback) { return }
                let respModel = ResponseModel()
                respModel.status = jsonData[responseCodeKey].int ?? -999
                respModel.message = jsonData[responseMessageKey].stringValue
                
                if respModel.status == successCode {
                    ProgressHUD.showSuccess("Success", image: nil, interaction: false)
                    respModel.data = jsonData[responseDataKey].rawString() ?? ""
                    successCallback(respModel)
                } else {
                    errorHandler(code: respModel.status, message: respModel.message, needShowFailAlert: needShowFailAlert, failure: failureCallback)
                }
            } catch {
                errorHandler(code: 10000, message: String(data: response.data, encoding: String.Encoding.utf8)!, needShowFailAlert: needShowFailAlert, failure: failureCallback)
            }
        case let .failure(error as NSError):
            errorHandler(code: error.code, message: "Network connection failure", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }
}

private func validateResponse(response: [String: JSON]?, needShowFailAlert: Bool, failure: RequestCallback?) -> Bool {
    return true
}

private func errorHandler(code: Int, message: String, needShowFailAlert: Bool, failure: RequestCallback?) {
    log.error("发生错误：\(code)--\(message)")
    let model = ResponseModel()
    model.status = code
    model.message = message
    if needShowFailAlert {
        log.error("弹出错误信息弹框\(message)")
        ProgressHUD.showError(message, image: nil, interaction: false)
    }
    failure?(model)
}

class ResponseModel {
    var status: Int = -999
    var message: String = ""
    var data: String = ""
}

extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true
    }
}
