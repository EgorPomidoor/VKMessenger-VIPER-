//
//  API_WRAPPER.swift
//  VKMessenger
//
//  Created by Егор on 18.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation
import SwiftyJSON

class API_WRAPPER {
    
    private class func complitionHandler (success: (JSON) -> Void, failure: (Int) -> Void, data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            let error = (error! as NSError).code
            failure(error)
        } else if data != nil {
            let jsonResponse = JSON(data as Any)
            success(jsonResponse)
        } else {
            failure(-3)
        }
    }
    
    class func getDialogs (count: Int, offset: Int, success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void) {
        let URLString = VKMConst.APIService.kBaseURL + VKMConst.URLMethods.kMessage + "?" + VKMConst.URLArguments.kCount + "=\(count)&" + VKMConst.URLArguments.kOffset + "=\(offset)&v=5.64&access_token=\(VKMAuthService.sharedInstance.getAccessToken())"
        let url = URL(string: URLString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            complitionHandler(success: success, failure: failure, data: data, response: response, error: error)
        })
        task.resume()
    }
    
    class func getUser (id: String, success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void) {
        let urlString = VKMConst.APIService.kBaseURL + VKMConst.URLMethods.kUser + "?" + VKMConst.URLArguments.kIds + "=\(id)&" + VKMConst.URLArguments.kFields + "=photo_100&v=5.8&access_token=\(VKMAuthService.sharedInstance.getAccessToken())"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            complitionHandler(success: success, failure: failure, data: data, response: response, error: error)
        })
        task.resume()
    }
    
    class func getDetailChat (id: Int64, count: Int, offset: Int, success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void) {
        let urlString = VKMConst.APIService.kBaseURL + VKMConst.URLMethods.kDetailChat + "?" + VKMConst.URLArguments.kUserId + "=\(id)&" + VKMConst.URLArguments.kCount + "=\(count)&" + VKMConst.URLArguments.kOffset + "=\(offset)&v=5.8&access_token=\(VKMAuthService.sharedInstance.getAccessToken())"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            complitionHandler(success: success, failure: failure, data: data, response: response, error: error)
        })
        task.resume()
    }
}
