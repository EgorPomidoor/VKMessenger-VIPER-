//
//  ViewController.swift
//  VKMessenger
//
//  Created by Егор on 14.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

   override func viewDidAppear(_ animated: Bool) {
    VKMAuthService.sharedInstance.auth(baseController: self, success: {
        print("успех авторизации - \(VKMAuthService.sharedInstance.getAccessToken())")
        print("айдишничек - \(Int64(VKMAuthService.sharedInstance.getMyID())!)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
        {
            // self.performSegue(withIdentifier: "loginSuccess", sender: self)
            let navController = UINavigationController()
            let router = ChatsListRouter()
            navController.setViewControllers([router.setUpModule()], animated: false)
            //navController.hidesBarsOnSwipe = true
            //navController.navigationBar.barTintColor = UIColor(red: 16/255, green: 42/255, blue: 18/255, alpha: 0.5)
           // navController.navigationBar.isTranslucent = false
            
            var bounds = navController.navigationBar.bounds
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            visualEffectView.frame = bounds
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bounds.offsetBy(dx: 0.0, dy: -20.0)
            bounds.size.height = bounds.height + 20.0
            navController.navigationBar.insertSubview(visualEffectView, at: 0)
            
            navController.navigationBar.topItem?.title = "Сообщения"
            navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            
            self.present(navController, animated: true, completion: nil)
            
            
            API_WRAPPER.getLongPollServer(success: { (response) in
                let key = response["response"]["key"].stringValue
                let server = response["response"]["server"].stringValue
                let ts = response["response"]["ts"].stringValue
                
                LongPollService.startLongPoll(key: key, server: server, ts: ts)
                
            }, failure: {(error) in
                print (error)
            })
        }
        
    }, failure: {[weak self] in
        
        let alertController = UIAlertController(title: nil, message: "Авторизация провалена", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self?.present(alertController, animated: true, completion: nil)
    })
    super.viewDidAppear(animated)
    }
    
}

