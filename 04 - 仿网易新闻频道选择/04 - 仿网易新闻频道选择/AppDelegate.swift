//
//  AppDelegate.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController()
        let navc = UINavigationController(rootViewController: homeVC)
        
        window?.rootViewController = navc
        window?.makeKeyAndVisible()
        
        return true
    }
}
