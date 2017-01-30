//
//  MainViewController.swift
//  StopAds
//
//  Created by Xiaohu on 10/4/15.
//  Copyright © 2015 Luokey. All rights reserved.
//

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

class MainCell: UITableViewCell {
    
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


class MainViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!;
    
    var enableAdTracking: Bool? = false
    var enableSocial: Bool? = false
    var enableImages: Bool? = false
    var enableScripts: Bool? = false
    var enableFonts: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadBlockingOptions", name: "loadBlockingOptions", object: nil)
        
        
        self.title = NSLocalizedString("StopAds", comment: "StopAds")
        
        self.setupCoreSpotlightSearch()
        self.loadBlockingOptions()
        self.checkTour()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (section == 0) {
            return 2
        }
        else if section == 1 {
            return 3
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return NSLocalizedString("ENABLE / DISABLE BLOCKING", comment: "ENABLE / DISABLE BLOCKING")
        }
        else if section == 1 {
            return NSLocalizedString("BLOCK RESOURCES WITH THESE FILETYPES", comment: "BLOCK RESOURCES WITH THESE FILETYPES")
        }
        else {
            return NSLocalizedString("PERSONALIZATION", comment: "PERSONALIZATION")
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 1) {
            return NSLocalizedString("For more aggressive blocking, you can additionally block whole resource types you find nonessential. Blocking fonts includes certain web icons.", comment: "For more aggressive blocking, you can additionally block whole resource types you find nonessential. Blocking fonts includes certain web icons.")
        }
        return ""
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MainCell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! MainCell

        // Configure the cell...
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.titleLabel?.text = NSLocalizedString("Ads and Tracking", comment: "Ads and Tracking")
                cell.enableSwitch.on = self.enableAdTracking!
            }
            else if (indexPath.row == 1) {
                cell.titleLabel?.text = NSLocalizedString("Social Buttons and Comments", comment: "Social Buttons and Comments")
                cell.enableSwitch.on = self.enableSocial!
            }
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.titleLabel?.text = NSLocalizedString("Images", comment: "Images")
                cell.enableSwitch.on = self.enableImages!
            }
            else if (indexPath.row == 1) {
                cell.titleLabel?.text = NSLocalizedString("Scripts", comment: "Scripts")
                cell.enableSwitch.on = self.enableScripts!
            }
            else {
                cell.titleLabel?.text = NSLocalizedString("Fonts", comment: "Fonts")
                cell.enableSwitch.on = self.enableFonts!
            }
        }
        else {
            cell.titleLabel?.text = NSLocalizedString("Whitelisted Sites", comment: "Whitelisted Sites")
        }
        
        cell.enableSwitch.tag = indexPath.section * 10 + indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.section == 2) {
            cell.enableSwitch.alpha = 0
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 2) {
            self.performSegueWithIdentifier("Segue_ShowWhiteList", sender: self)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Main methods
    
    @IBAction func tapMusicButton(sender: UIButton) {
        
        let safariVC: SFSafariViewController = SFSafariViewController(URL: NSURL(string: "http://bit.ly/noadsmusic")!)
        safariVC.delegate = self
        
        self.presentViewController(safariVC, animated: true, completion: { () -> Void in
            
        })
    }
    
    @IBAction func valueChanged(sender: UISwitch) {
        
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: Utils.GroupName)!
        
        if (sender.tag == 0) {
            self.enableAdTracking = sender.on
            
            userDefaults.setBool(self.enableAdTracking!, forKey: Utils.key_enableAdTracking)
            userDefaults.synchronize()
            
        }
        else if (sender.tag == 1) {
            self.enableSocial = sender.on
            
            userDefaults.setBool(self.enableSocial!, forKey: Utils.key_enableSocial)
            userDefaults.synchronize()
            
        }
        else if (sender.tag == 10) {
            self.enableImages = sender.on
            
            userDefaults.setBool(self.enableImages!, forKey: Utils.key_enableImages)
            userDefaults.synchronize()
        }
        else if (sender.tag == 11) {
            self.enableScripts = sender.on
            
            userDefaults.setBool(self.enableScripts!, forKey: Utils.key_enableScripts)
            userDefaults.synchronize()
        }
        else if (sender.tag == 12) {
            self.enableFonts = sender.on
            
            userDefaults.setBool(self.enableFonts!, forKey: Utils.key_enableFonts)
            userDefaults.synchronize()
        }
        
        SFContentBlockerManager.reloadContentBlockerWithIdentifier(Utils.BlockerIdentifier) { (error) -> Void in
        }
    }
    
    func setupCoreSpotlightSearch() {
        
        let attributeSet: CSSearchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeImage as String)
        attributeSet.title = "StopAds"
        attributeSet.contentDescription = ""
        attributeSet.keywords = ["youtube ad blocker", "youtube ad blocking", "adblock", "ad-block", "adblocker", "ad-blocker", "adblocking", "ad-blocking", "adblocks", "ad-blocks", "block ads", "ad blocker", "ad blocking", "safari ad blocker", "safari ad blocking", "privacy ad blocker", "unblock sites", "ad blocker browser", "ad blocking browser", "ad block browser", "fast browsing", "faster browsing", "no ads safari", "ad blocker app", "no ads", "no tracking", "fast safari", "chrome", "safari", "firebox", "opera", "facebook", "instagram", "adware", "ad", "ware", "popup", "pop up", "pop", "up", "tracking", "adwords", "adware"]
        
        let image: UIImage = UIImage(named: "Logo.png")!
        let imageData: NSData = NSData(data: UIImagePNGRepresentation(image)!)
        attributeSet.thumbnailData = imageData;
        
        let item: CSSearchableItem = CSSearchableItem(uniqueIdentifier: "com.chino.stopads", domainIdentifier: "spotlight.chino.stopads", attributeSet: attributeSet)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error) -> Void in
            if (error == nil) {
                NSLog("Search item indexed!")
            }
        }
    }
    
    func loadBlockingOptions() {
        
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: Utils.GroupName)!
        
        self.enableAdTracking = userDefaults.boolForKey(Utils.key_enableAdTracking)
        self.enableSocial = userDefaults.boolForKey(Utils.key_enableSocial)
        self.enableImages = userDefaults.boolForKey(Utils.key_enableImages)
        self.enableScripts = userDefaults.boolForKey(Utils.key_enableScripts)
        self.enableFonts = userDefaults.boolForKey(Utils.key_enableFonts)
        
        self.mainTableView.reloadData()
    }
    
    func checkTour() {
        
        if (!NSUserDefaults.standardUserDefaults().boolForKey(Utils.key_StopAdsTour)) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Utils.key_StopAdsTour)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.performSegueWithIdentifier(Utils.Segue_ShowTour, sender: self)
        }
    }
    
    // MARK: - SFSafariViewController delegate
    
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity] {
        
        NSLog("safariViewController:activityItemsForURL:title")
        return []
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        NSLog("safariViewControllerDidFinish")
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
        NSLog("safariViewController:didCompleteInitialLoad")
    }
}
