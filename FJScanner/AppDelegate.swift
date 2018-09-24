//
//  AppDelegate.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/3.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarVC: UITabBarController?
    var tabOneNav: UINavigationController?
    var tabTwoNav: UINavigationController?
    
    var rootOneVC: FJScannerViewController?
    var rootTwoVC: FJCollectorViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.rootOneVC = FJScannerViewController()
        self.rootTwoVC = FJCollectorViewController()
        
        self.tabBarVC = UITabBarController.init()
        self.tabOneNav = UINavigationController.init(rootViewController: self.rootOneVC!)
        self.tabTwoNav = UINavigationController.init(rootViewController: self.rootTwoVC!)
        
        self.tabBarVC?.setViewControllers([self.tabOneNav!,self.tabTwoNav!], animated: true)
        self.tabOneNav?.tabBarItem.title = "视界"
        self.tabOneNav?.tabBarItem.image = UIImage.init(named: "camera")
        self.tabTwoNav?.tabBarItem.title = "我的"
        self.tabTwoNav?.tabBarItem.image = UIImage.init(named: "mine")
        
        self.window?.rootViewController = self.tabBarVC;
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
