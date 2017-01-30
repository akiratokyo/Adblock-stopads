//
//  ActionViewController.swift
//  StopAdsAction
//
//  Created by Xiaohu on 10/8/15.
//  Copyright © 2015 Luokey. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class ActionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionTableView: UITableView!
    
    var url: NSURL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        //        var imageFound = false
        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                //                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                //                    // This is an image. We'll load it, then place it in our image view.
                //                    weak var weakImageView = self.imageView
                //                    itemProvider.loadItemForTypeIdentifier(kUTTypeImage as String, options: nil, completionHandler: { (image, error) in
                //                        NSOperationQueue.mainQueue().addOperationWithBlock {
                //                            if let strongImageView = weakImageView {
                //                                strongImageView.image = image as? UIImage
                //                            }
                //                        }
                //                    })
                //
                //                    imageFound = true
                //                    break
                //                }
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    itemProvider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler: { (urlItem, error) -> Void in
                        self.url = urlItem as? NSURL
                        self.actionTableView!.reloadData()
                    })
                }
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    // You _HAVE_ to call loadItemForTypeIdentifier in order to get the JS injected
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil, completionHandler: {
                        (list, error) in
                        if let results = list as? NSDictionary {
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                // We don't actually care about this...
                                print(results)
                            }
                        }
                    })
                }
            }
            
            //            if (imageFound) {
            //                // We only handle one image, so stop looking for more.
            //                break
            //            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        
        let cell: ActionCell? = self.actionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ActionCell
        self.setMemberOfWhiteList(self.url?.host, isMember: cell?.enableSwitch.on)
        
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return NSLocalizedString("WHITELIST", comment: "WHITELIST")
        }
        return""
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return NSLocalizedString("Enable/disable whitelisting for this site.", comment: "Enable/disable whitelisting for this site.")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ActionCell = tableView.dequeueReusableCellWithIdentifier("ActionCell", forIndexPath: indexPath) as! ActionCell
        
        // Configure the cell...
        
        print("\(self.url)")
        if (self.url != nil) {
            cell.titleLabel?.text = self.url!.host
            cell.enableSwitch.hidden = false
            cell.enableSwitch.on = self.isMemberOfWhiteList(self.url?.host)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func isMemberOfWhiteList(urlString: String?) -> Bool {
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.chino.stopads")!
        let whitelist: NSMutableDictionary? = userDefaults.objectForKey("StopAdsWhitelist") as? NSMutableDictionary
        if (whitelist != nil) {
            let isMember: NSNumber? = whitelist?.objectForKey(urlString!) as? NSNumber
            if (isMember != nil) {
                return isMember!.boolValue
            }
        }
        return false
    }
    
    func setMemberOfWhiteList(urlString: String?, isMember: Bool?) {
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.chino.stopads")!
        var whitelist: NSMutableDictionary? = NSMutableDictionary(capacity: 0)
        let info: NSDictionary? = userDefaults.objectForKey("StopAdsWhitelist") as? NSDictionary
        if (info != nil) {
            whitelist = NSMutableDictionary(dictionary: info!)
        }
        
        if (whitelist == nil) {
            whitelist = NSMutableDictionary(capacity: 0)
        }
        
        whitelist?.removeObjectForKey(urlString!)
        if (isMember!) {
            whitelist?.setObject(NSNumber(bool: isMember!), forKey: urlString!)
        }
        
        userDefaults.setObject(whitelist, forKey: "StopAdsWhitelist")
        userDefaults.synchronize()
    }
}
