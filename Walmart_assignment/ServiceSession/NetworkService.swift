//
//  NetworkService.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation
import UIKit

struct HTTPResponse {
    static let kSuccess = 200
    static let kCreated = 201
    static let kUnauthorized = 401
    static let kForbidden = 403
    static let kNotFound = 404
    static let kNotAvailable = 400
    static let kServerError = 500
}

enum HTTPMethod {
    static let kPost = "POST"
    static let kPut = "PUT"
    static let kGet = "GET"
}

struct ConnectionFeedbackMessage {
    static let kNotConnectedToInternet : String  = "We are not connected to the internet, showing you the last image we have."
    static let kInternetOffline : String = "The Internet connection appears to be offline"
    static let kInternalServerError : String = "Internal server error"
}

typealias completionHandler = (_ data: Any,_ responseCode: Int) -> Void

class NetworkService: NSObject {
    
    class var sharedServiceSession:NetworkService {
        struct sharedServiceSession {
            static let instance = NetworkService()
        }
        return sharedServiceSession.instance
    }
    
    let session  = URLSession.shared
    var urlRequest: URLRequest! = nil

    // MARK: - GET
    func getMethodURLRequest(controller: UIViewController, appendKey: String, completionHandler: @escaping completionHandler) {
        
        let urlStr =  String(format: "%@\(appendKey)",(BASE_URL))
        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: urlString!) {
                        
            urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = HTTPMethod.kGet
            
            urlRequest.addValue("IOS", forHTTPHeaderField: "platform")
            urlRequest.addValue(UUID().uuidString, forHTTPHeaderField: "correlationId")
                        
            session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                
                if data == nil && error == nil {
                    Helper.sharedInstance.internalServerErrorAlertView(controller: controller)
                    return
                } else if error != nil {
                    print("fail to connect with error:\((error?.localizedDescription)!)")
                    Helper.sharedInstance.errorAlertView(controller: controller, error: error! as NSError)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    
                } catch {
                    print("failed to Get data from Server with error:%@", error)
                    Helper.sharedInstance.errorAlertView(controller: controller, error: error as NSError)
                }
            }).resume()
        }
    }
    
    
}
