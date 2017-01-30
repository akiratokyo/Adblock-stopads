//
//  WhiteListViewController.swift
//  StopAds
//
//  Created by Xiaohu on 10/7/15.
//  Copyright © 2015 Luokey. All rights reserved.
//

import UIKit

class WhiteListViewController: UIViewController {
    
    @IBOutlet weak var whitelistTableView: UITableView!;
    
    var whitelist: NSMutableArray?
    var editBarButtonItem: UIBarButtonItem?
    var deleteBarButtonItem: UIBarButtonItem?
    var cancelBarButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadWhitelist", name: "loadWhitelist", object: nil)
        
        
        self.editBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("tapEditButton"))
        self.deleteBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Delete", comment: "Delete"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("tapDeleteButton"))
        self.cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("tapCancelButton"))
        
        self.title = NSLocalizedString("Whitelisted Sites", comment: "Whitelisted Sites")
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // load whitelist items
        self.loadWhitelist()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.whitelist!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WhitelistCell", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = self.whitelist?.objectAtIndex(indexPath.row) as? String

        return cell
    }

    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let moveItem: String? = self.whitelist?.objectAtIndex(fromIndexPath.row) as? String
        
        self.whitelist?.removeObjectAtIndex(fromIndexPath.row)
        self.whitelist?.insertObject(moveItem!, atIndex: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        return proposedDestinationIndexPath
    }
    
    
    // MARK: - UITableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)")
        
        let selectedIndexPaths: NSArray? = self.whitelistTableView.indexPathsForSelectedRows
        self.deleteBarButtonItem?.enabled = selectedIndexPaths?.count > 0
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedIndexPaths: NSArray? = self.whitelistTableView.indexPathsForSelectedRows
        self.deleteBarButtonItem?.enabled = selectedIndexPaths?.count > 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Main methods
    
    func loadWhitelist() {
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: Utils.GroupName)!
        var whitelistInfo: NSMutableDictionary? = NSMutableDictionary(capacity: 0)
        let info: NSDictionary? = userDefaults.objectForKey(Utils.key_StopAdsWhitelist) as? NSDictionary
        if (info != nil) {
            whitelistInfo = NSMutableDictionary(dictionary: info!)
        }
        
        self.whitelist = NSMutableArray(array: (whitelistInfo?.allKeys)!)
        self.whitelistTableView.reloadData()
        
        self.editBarButtonItem?.enabled = self.whitelist?.count > 0
    }
    
    func tapEditButton() {
        self.whitelistTableView.setEditing(true, animated: true)
        
        self.navigationItem.leftBarButtonItem = self.deleteBarButtonItem
        self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem
        
        self.deleteBarButtonItem?.enabled = false
    }
    
    func tapDeleteButton() {
        
        let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: Utils.GroupName)!
        var whitelistInfo: NSMutableDictionary? = NSMutableDictionary(capacity: 0)
        let info: NSDictionary? = userDefaults.objectForKey(Utils.key_StopAdsWhitelist) as? NSDictionary
        if (info != nil) {
            whitelistInfo = NSMutableDictionary(dictionary: info!)
        }
        
        let selectedIndexPaths: NSArray? = self.whitelistTableView.indexPathsForSelectedRows
        for item: AnyObject in selectedIndexPaths! {
            let indexPath: NSIndexPath? = item as? NSIndexPath
            let keyString: NSString? = self.whitelist?.objectAtIndex(indexPath!.row) as? NSString
            
            whitelistInfo?.removeObjectForKey(keyString!)
        }
        
        userDefaults.setObject(whitelistInfo, forKey: Utils.key_StopAdsWhitelist)
        userDefaults.synchronize()
        
        
        self.whitelist = NSMutableArray(array: (whitelistInfo?.allKeys)!)
        self.whitelistTableView.reloadData()
        
        
        self.deleteBarButtonItem?.enabled = self.whitelist?.count > 0
        if (self.whitelist?.count < 1) {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = self.editBarButtonItem
            self.editBarButtonItem?.enabled = false
        }
    }
    
    func tapCancelButton() {
        self.whitelistTableView.setEditing(false, animated: true)
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
        self.editBarButtonItem?.enabled = self.whitelist?.count > 0
    }
}
