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
    func layoutTableView()
    var red: UIColor {get set}
    var orange: UIColor {get set}
    var yellow: UIColor {get set}
    var green: UIColor {get set}
    var blue: UIColor {get set}
    var lightGrey: UIColor {get set}
    var darkGrey: UIColor {get set}
}

protocol AssignViewDelegate {
    func dismissAssignView(index:NSIndexPath?)
    var assignee: String {get set}
}

protocol TicketViewDelegate {
    var users: [PFObject] {get}
    var red: UIColor {get set}
    var orange: UIColor {get set}
    var green: UIColor {get set}
    var blue: UIColor {get set}
    var lightGrey: UIColor {get set}
    var darkGrey: UIColor {get set}
}


class TicketListViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, TaskCellDelegate, AssignViewDelegate, TicketViewDelegate {

    @IBOutlet var ticketTableView: UITableView!
    var tickets: [PFObject] = []
    var expanded: [Bool] = []
    var users: [PFObject] = []
    var timer: NSTimer = NSTimer()
    var currentUser = "brandon"
    var currentUserType = "staff"
    var assignView: AssignView!
    var assignee: String = ""
    
    var red: UIColor = UIColor(red: 1.0, green: 0.404, blue: 0.404, alpha: 1.0) //#FF6767
    var orange: UIColor = UIColor(red: 1.0, green: 0.745, blue: 0.42, alpha: 1.0) //#FFBE6B
    var yellow: UIColor = UIColor(red: 1.0, green: 0.9, blue: 0.404, alpha: 1.0)
    var green: UIColor = UIColor(red: 0.549, green: 0.749, blue: 0.439, alpha: 1.0) //#8CBF70
    var blue: UIColor = UIColor(red: 0.502, green: 0.69, blue: 0.871, alpha: 1.0) //#80B0DE
    var lightGrey: UIColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0) //#5B5B5B
    var darkGrey: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.239, alpha: 1.0) //#5B5B5B
    
    var selectedCell: NSIndexPath!
    var prototypeCell: TaskTableViewCell!
    let taskIdent: String = "taskCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "Tasks"
        ticketTableView.delegate = self
        ticketTableView.dataSource = self
        ticketTableView.rowHeight = UITableViewAutomaticDimension
        ticketTableView.estimatedRowHeight = 260.0
        
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
//        ticketTableView.registerNib(nib, forCellReuseIdentifier: taskIdent)
//        prototypeCell = ticketTableView.dequeueReusableCellWithIdentifier(taskIdent) as? TaskTableViewCell
        
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "completeCell")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "completedCell")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "assignCell")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "acceptCell")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "completeCellExpanded")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "completedCellExpanded")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "assignCellExpanded")
        ticketTableView.registerNib(nib, forCellReuseIdentifier: "acceptCellExpanded")
        
        refreshUserList()
        refreshTicketList()
        timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "refreshTicketList", userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshTicketList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.navigationController?.navigationBar.barTintColor = self.darkGrey
        }
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
            self.expanded.removeAtIndex(indexPaths[0].row)
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
        query.addDescendingOrder("priority")

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
                        self.expanded = [Bool](count: self.tickets.count, repeatedValue: false)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.ticketTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                            //                    self.ticketTableView.reloadData()
                        })
                    }

                } else {
                    self.tickets = []
                    self.expanded = []
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
    
    func layoutTableView() {
        ticketTableView.layoutIfNeeded()
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
//        let expanded = (self.selectedCell != nil && self.selectedCell == indexPath)
        let expand = expanded[indexPath.row]
        let cellType = checkCellType(ticket, expanded: expand)
        
        var childType = cellType
        if(expand) { childType += "Expanded" }

        let cell = tableView.dequeueReusableCellWithIdentifier(childType) as? TaskTableViewCell
        
        cell!.delegate = self
        cell!.populateCell(tickets[indexPath.row], currentUser: currentUser)
        cell!.customizeCell(cellType, expanded: expand)
        cell!.index = indexPath
        
        return cell!
    }
    
    
    func checkCellType(ticket: PFObject, expanded: Bool) -> String {
        let accepted = ticket["accepted"] as? String
        let assignee = ticket["assignee"] as? String
        let completed = ticket["completed"] as? String
        var cellType = ""
        
        if(assignee == currentUser && (completed == nil || completed == "N" )){
            if(accepted == nil || accepted == "N"){
                cellType = "acceptCell"
            } else {
                cellType = "completeCell"
            }
        } else if(completed == nil || completed == "N" ) {
            cellType = "assignCell"
        } else {
            cellType = "completedCell"
        }
        return cellType
    }
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var previousCell: TaskTableViewCell?
        
        // Get current cell and toggle expansion
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TaskTableViewCell
        cell.toggleCellExpansion()
        
        expanded[indexPath.row] = !expanded[indexPath.row]
        
        // Update selected cell
        if selectedCell != nil {
            expanded[selectedCell.row] = !expanded[selectedCell.row]
            if selectedCell == indexPath { selectedCell = nil }
            else {
                // Get previous selected cell
                previousCell = tableView.cellForRowAtIndexPath(selectedCell) as? TaskTableViewCell
                previousCell?.toggleCellExpansion()
                
                selectedCell = indexPath
            }
        } else {
            selectedCell = indexPath
        }
        
        tableView.beginUpdates()
        UIView.animateWithDuration(0.25) { () -> Void in
            previousCell?.contentView.layoutIfNeeded()
            previousCell?.animateCellExpansion()
            cell.contentView.layoutIfNeeded()
            cell.animateCellExpansion()
        }
        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(expanded[indexPath.row]){
            return 600.0
        } else {
            return 200.0
        }
    }
}
