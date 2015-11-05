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
    func assignTicket(index: NSIndexPath)
    func refreshTickets(indexPaths: [NSIndexPath], remove: Bool)
    var red: UIColor {get set};
    var orange: UIColor {get set};
    var green: UIColor {get set};
    var blue: UIColor {get set};
    var lightGrey: UIColor {get set};
    var darkGrey: UIColor {get set};
}

protocol AssignViewDelegate {
    func dismissAssignView(index:NSIndexPath?)
    var assignee: String {get set}
}

protocol TicketViewDelegate {
    var users: [PFObject] {get}
    var red: UIColor {get set};
    var orange: UIColor {get set};
    var green: UIColor {get set};
    var blue: UIColor {get set};
    var lightGrey: UIColor {get set};
    var darkGrey: UIColor {get set};
}


class TicketListViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, TaskCellDelegate, AssignViewDelegate, TicketViewDelegate {

    @IBOutlet var ticketTableView: UITableView!
    var tickets: [PFObject] = []
    var users: [PFObject] = []
    var timer: NSTimer = NSTimer()
    var currentUser = "brandon"
    var currentUserType = "staff"
    var assignView: AssignView!
    var assignee: String = ""
    
    var red: UIColor = UIColor(red: 1.0, green: 0.404, blue: 0.404, alpha: 1.0) //#FF6767
    var orange: UIColor = UIColor(red: 1.0, green: 0.745, blue: 0.42, alpha: 1.0) //#FFBE6B
    var green: UIColor = UIColor(red: 0.549, green: 0.749, blue: 0.439, alpha: 1.0) //#8CBF70
    var blue: UIColor = UIColor(red: 0.502, green: 0.69, blue: 0.871, alpha: 1.0) //#80B0DE
    var lightGrey: UIColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0) //#5B5B5B
    var darkGrey: UIColor = UIColor(red: 0.357, green: 0.357, blue: 0.357, alpha: 1.0) //#5B5B5B
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketTableView.delegate = self
        ticketTableView.dataSource = self
        ticketTableView.rowHeight = UITableViewAutomaticDimension
        ticketTableView.estimatedRowHeight = 260.0
        
        var nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "completeCell")
        nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "completedCell")
        nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "assignCell")
        nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "acceptCell")
        
        refreshUserList()
        refreshTicketList()
        timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "refreshTicketList", userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshTicketList()
    }
    
    func dismissAssignView(index: NSIndexPath?) {
        if(assignView != nil){
            assignView.removeFromSuperview()
            
            if(index != nil){
                
                let objectID = tickets[(index?.row)!].objectId
                let query = PFQuery(className:"Ticket")
                query.getObjectInBackgroundWithId(objectID!) {
                    (ticket: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else if let ticket = ticket {
                        let date = NSDate()
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM dd, yy, hh:mm"
                        ticket["assigned"] = dateFormatter.stringFromDate(date)
                        ticket["assignee"] = self.assignee
                        ticket.saveInBackground()
                        
                        let push = PFPush()
                        push.setChannel("tickets")
                        push.setMessage("A new task needs attention")
                        self.refreshTickets([index!], remove: false)
                    }
                }
            }
        }
    }

    @IBAction func AddButtonPressed(sender: AnyObject) {
        
        let newTicketView = TicketViewController()
        newTicketView.creator = currentUser
        newTicketView.currentUserType = currentUserType
        newTicketView.delegate = self
        newTicketView.view.backgroundColor = lightGrey
        navigationController?.pushViewController(newTicketView, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTickets(indexPaths: [NSIndexPath], remove: Bool){
        self.ticketTableView.beginUpdates()
        if(remove) {
            self.tickets.removeAtIndex(indexPaths[0].row)
            self.ticketTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        } else {
            self.ticketTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }
        self.ticketTableView.endUpdates()
    }
    
    func refreshTicketList() {
        let query = PFQuery(className:"Ticket")
        
        switch(currentUserType){
            case "staff":
                query.whereKey("assignee", equalTo:currentUser)
                query.whereKey("completed", equalTo: "N")
                query.orderByAscending("assigned")
                break
            case "manager":
                query.orderByAscending("assigned")
                query.orderByDescending("completed")
                break
        default:
            break
        }

        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) tickets.")
                // Do something with the found objects
                if (objects != nil) {
                    if(self.tickets != objects!){
                        print("Updating Table")
                        self.tickets = objects!
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.ticketTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                            //                    self.ticketTableView.reloadData()
                        })
                    }

                } else {
                    self.tickets = []
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func refreshUserList() {
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
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
    
    func assignTicket(index: NSIndexPath) {
        assignView = AssignView(frame: view.frame)
        assignView.delegate = self
        assignView.staffList = users
//        assignView.objectID = tickets[index.row].objectId
        view.addSubview(assignView)
        
        assignView.bringUp(index)
        
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
        
        let ticket = tickets[indexPath.row]
        let cellType = checkCellType(ticket)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellType) as? TaskTableViewCell
        
        cell!.delegate = self
        cell!.customizeCell(cellType)
        cell!.populateCell(tickets[indexPath.row], currentUser: currentUser)
        cell!.index = indexPath
        return cell!
    }
    
    func checkCellType(ticket: PFObject) -> String {
        let accepted = ticket["accepted"] as? String
        let assignee = ticket["assignee"] as? String
        let completed = ticket["completed"] as? String
        
        if(assignee == currentUser && (completed == nil || completed == "N" )){
            if(accepted == nil || accepted == "N"){
                return "acceptCell"
            } else {
                return "completeCell"
            }
        } else if(completed == nil || completed == "N" ) {
            return "assignCell"
        } else {
            return "completedCell"
        }
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
