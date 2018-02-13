//
//  VKMAuthService.swift
//  VKMessenger
//
//  Created by Егор on 14.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit
import VK_ios_sdk
//MARK:- интерфейс
class VKMAuthService: NSObject {
    
    static let sharedInstance = VKMAuthService()
    private let sdkInstance = VKSdk.initialize(withAppId: "6281345")
    
    weak var baseController: UIViewController?
    var success: (() -> Void)?
    var failure: (() -> Void)?
    
    func auth (baseController: UIViewController, success: @escaping () -> Void, failure: @escaping () -> Void) {
        
        
        if getAccessToken() != "" {
            success()
            return
        }
        
        self.baseController = baseController
        self.success = success
        self.failure = failure
        
        let scope = ["friends","messages","offline"]
        
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        
        VKSdk.authorize(scope)
        
      
    }
}


//MARK:- логика авторизации
extension VKMAuthService: VKSdkUIDelegate,VKSdkDelegate {
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        baseController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        let token = result.token
       
        
        if token != nil {
            let tokenStr = token!.accessToken
            
            if tokenStr != nil {
                setAccessToken(token: tokenStr!)
                setMyID(identif: result.token!.userId)
                success?()
                return
            }
        }
        failure?()
    }
    
    func vkSdkUserAuthorizationFailed() {
        print ("авторизация не удалась")
        failure?()
    }
    
    func process (url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) {
        VKSdk.processOpen(url, fromApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String! )
    }
}


//MARK:- логика хранения токена
extension VKMAuthService {
    
    private func setAccessToken ( token: String) {
        UserDefaults.standard.set(token, forKey: "FUCK")
        UserDefaults.standard.synchronize()
    }
    
    func getAccessToken () -> String {
        if let tokenStr = UserDefaults.standard.object(forKey: "FUCK") as? String {
            return tokenStr
        }
        return ""
    }
    
    private func setMyID ( identif: String) {
        UserDefaults.standard.set(identif, forKey: "FUCKKK")
        UserDefaults.standard.synchronize()
    }
    
    func getMyID () -> String {
        if let idStr = UserDefaults.standard.object(forKey: "FUCKKK") as? String {
            return idStr
        }
        return ""
    }
}
