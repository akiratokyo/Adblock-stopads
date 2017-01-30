//
//  AppDelegate.swift
//  StopAds
//
//  Created by Xiaohu on 10/8/15.
//  Copyright © 2015 Luokey. All rights reserved.
//

import UIKit
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let branch: Branch = Branch.getInstance()
        branch.initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
            if (error == nil) {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
                // ... insert custom logic here ...
                NSLog("params: %@", params.description)
            }
            else {
                NSLog("Failed init: %@", error)
            }
        })
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        NSNotificationCenter.defaultCenter().postNotificationName("loadBlockingOptions", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("loadWhitelist", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // pass the url to the handle deep link call
        
        Branch.getInstance().handleDeepLink(url);
        return true
        
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
//        return Branch.getInstance().handleDeepLink(url);
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        
        Branch.getInstance().continueUserActivity(userActivity);
        return true
        
//        let handledByBranch: Bool? = Branch.getInstance().continueUserActivity(userActivity)
//        return handledByBranch!
    }
}

