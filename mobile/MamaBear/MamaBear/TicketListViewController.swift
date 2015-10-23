//
//  TicketListViewController.swift
//  MamaBear
//
//  Created by Brandon Plaster on 10/22/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit
import Parse

protocol TaskCellDelegate {
    func refreshTicketList()
}


class TicketListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {

    @IBOutlet var ticketTableView: UITableView!
    var tickets: [PFObject] = []
    var users: [PFObject] = []
    var timer: NSTimer = NSTimer()
    var currentUser = "brandon"
    var currentUserType = "manager"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketTableView.delegate = self
        ticketTableView.dataSource = self
        ticketTableView.rowHeight = UITableViewAutomaticDimension
        ticketTableView.estimatedRowHeight = 240.0
        
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "TaskTableViewCell")
        
        refreshUserList()
        refreshTicketList()
//        timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "refreshTicketList", userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshTicketList()
    }

    @IBAction func AddButtonPressed(sender: AnyObject) {
        let newTicketView = TicketViewController()
        newTicketView.creator = currentUser
        presentViewController(newTicketView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTicketList() {
        let query = PFQuery(className:"Ticket")
        
        switch(currentUserType){
            case "staff":
                query.whereKey("assignee", equalTo:currentUser)
                break
        default:
            break
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if (objects != nil) {
                    self.tickets = objects!
                } else {
                    self.tickets = []
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.ticketTableView.reloadData()
                })
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func refreshUserList() {
        let query = PFQuery(className: "User")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if (objects != nil) {
                    self.users = objects!
                } else {
                    self.users = []
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskTableViewCell") as! TaskTableViewCell
        cell.populateCell(tickets[indexPath.row], users: users, currentUser: currentUser)
        cell.cellDelegate = self
        return cell
    }


    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
