//
//  ActionRequestHandler.swift
//  ContentBlocker
//
//  Created by Xiaohu on 10/8/15.
//  Copyright © 2015 Luokey. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        let adsAttachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json"))!
        let socialAttachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("social", withExtension: "json"))!
        let imagesAttachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("images", withExtension: "json"))!
        let scriptsAttachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("scripts", withExtension: "json"))!
        let fontsAttachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("fonts", withExtension: "json"))!
        
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.chino.stopads")!
        userDefaults.setBool(true, forKey: "enableAdTracking")
        userDefaults.synchronize()
        
        let enableAdTracking = userDefaults.boolForKey("enableAdTracking")
        let enableSocial = userDefaults.boolForKey("enableSocial")
        let enableImages = userDefaults.boolForKey("enableImages")
        let enableScripts = userDefaults.boolForKey("enableScripts")
        let enableFonts = userDefaults.boolForKey("enableFonts")
        
        
        let attachments: NSMutableArray = NSMutableArray(capacity: 0)
        
        if enableAdTracking {
            NSLog("Enable AdsTracking...")
            attachments.addObject(adsAttachment)
        }
        else {
            NSLog("Disable AdsTracking...")
        }
        
        if enableSocial {
            NSLog("Enable Social...")
            attachments.addObject(socialAttachment)
        }
        else {
            NSLog("Disable Social...")
        }
        
        if enableImages {
            NSLog("Enable Images...")
            attachments.addObject(imagesAttachment)
        }
        else {
            NSLog("Disable Images...")
        }
        
        if enableScripts {
            NSLog("Enable Scripts...")
            attachments.addObject(scriptsAttachment)
        }
        else {
            NSLog("Disable Scripts...")
        }
        
        if enableFonts {
            NSLog("Enable Fonts...")
            attachments.addObject(fontsAttachment)
        }
        else {
            NSLog("Disable Fonts...")
        }
        
        
        let item = NSExtensionItem()
        item.attachments = attachments as [AnyObject]
        
        context.completeRequestReturningItems([item], completionHandler: nil);
    }
    
    
    
//    func beginRequestWithExtensionContext(context: NSExtensionContext) {
//        let attachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json"))!
//
//        let item = NSExtensionItem()
//        item.attachments = [attachment]
//
//        context.completeRequestReturningItems([item], completionHandler: nil);
//    }
}
