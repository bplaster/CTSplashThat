//
//  TaskTableViewCell.swift
//  MamaBear
//
//  Created by Brandon Plaster on 10/22/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit
import Parse

class TaskTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var typeImageView: UIImageView!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var detailViewHeight: NSLayoutConstraint!
    @IBOutlet var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var assignButton: UIButton!
    @IBOutlet var buttonView: UIView!
    
    @IBOutlet var buttonViewBackgroundMargin: NSLayoutConstraint!
    var acceptButton: UIButton!
    var completeButton: UIButton!
    
    var assignedStatusView: StatusInfoView!
    var acceptedStatusView: StatusInfoView!
    var completedStatusView: StatusInfoView!
    
    var delegate: TaskCellDelegate!
        
    var accepted : String!
    var assigned : String!
    var assignee : String!
    var completed : String!
    var objectID : String!
    var priority : Int!
    
    var expanded : Bool = false
    var customized : Bool = false
    var index: NSIndexPath!
    
    let compressedHeight : CGFloat = 0.0
    var expandedHeight : CGFloat = 165.0
    let singleLineHeight : CGFloat = 40.0
    let largeButtonHeight : CGFloat = 50.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create constraint to allow for expanding views
//        autoresizingMask = UIViewAutoresizing.FlexibleHeight
        selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    @IBAction func assignButtonPressed(sender: AnyObject) {
        delegate.assignTicket(index)
    }
    
    @IBAction func declineButtonPressed(sender: AnyObject) {
        let query = PFQuery(className:"Ticket")
        query.getObjectInBackgroundWithId(objectID) {
            (ticket: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let ticket = ticket {
                ticket["accepted"] = "N"
                ticket["assigned"] = "N"
                ticket["assignee"] = "N"
                ticket.saveInBackground()
                
                self.delegate.refreshTickets([self.index], remove: false)
            }
        }

    }

    func acceptButtonPressed() {
        let query = PFQuery(className:"Ticket")
        query.getObjectInBackgroundWithId(objectID) {
            (ticket: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let ticket = ticket {
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM dd, yy, hh:mm"
                ticket["accepted"] = dateFormatter.stringFromDate(date)
                ticket.saveInBackground()
                
                self.delegate.refreshTickets([self.index], remove: false)
            }
        }
    }
    
    func completeButtonPressed() {
        let query = PFQuery(className:"Ticket")
        query.getObjectInBackgroundWithId(objectID) {
            (ticket: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let ticket = ticket {
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM dd, yy, hh:mm"
                ticket["completed"] = dateFormatter.stringFromDate(date)
                ticket.saveInBackground()
                
                self.delegate.refreshTickets([self.index], remove: true)
            }
        }

    }
    
    func customizeCell(type:String, expanded:Bool){
        
        self.expanded = expanded
        var height = compressedHeight
        if expanded {
            height = expandedHeight
        }

        detailViewHeight.constant = height
        
        confirmButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        contentView.backgroundColor = delegate.lightGrey
        
        switch(priority) {
        case 1:
            headerView.backgroundColor = delegate.yellow
            break
        case 2:
            headerView.backgroundColor = delegate.orange
            break
        case 3:
            headerView.backgroundColor = delegate.red
            break
        default:
            headerView.backgroundColor = delegate.orange
            break
        }
        
        switch(type) {
            case "acceptCell":
                buttonView.hidden = false
                typeImageView.image = UIImage(named: "icon_2")
                buttonViewBackgroundMargin.constant = 2.0
                buttonViewHeight.constant = largeButtonHeight
                confirmButton.setTitle(" ACCEPT", forState: UIControlState.Normal)
                confirmButton.addTarget(self, action: "acceptButtonPressed", forControlEvents: .TouchUpInside)
                break;
            case "completeCell":
                buttonView.hidden = false
                typeImageView.image = UIImage(named: "time")
                buttonViewBackgroundMargin.constant = 2.0
                buttonViewHeight.constant = largeButtonHeight
                confirmButton.setTitle(" COMPLETE", forState: UIControlState.Normal)
                confirmButton.addTarget(self, action: "completeButtonPressed", forControlEvents: .TouchUpInside)
                break;
            case "assignCell":
                typeImageView.image = UIImage(named: "exclamation")
                buttonView.hidden = true
                buttonViewBackgroundMargin.constant = 0.0
                buttonViewHeight.constant = 0.0

                break;
        default:

            buttonView.hidden = true
            typeImageView.image = UIImage(named: "icon_4")
            buttonViewBackgroundMargin.constant = 0.0

            buttonViewHeight.constant = 0.0
            assignButton.enabled = false
            assignButton.setTitle("COMPLETED By " + assignee, forState: UIControlState.Disabled)

            contentView.alpha = 0.6
            break;
        }
        
        customized = true
    }
    
    func populateCell(ticket: PFObject, currentUser: String){
        
        titleLabel.text = ticket["title"] as? String
        descLabel.text = ticket["description"] as? String
        
        let date = ticket.createdAt
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        creatorLabel.text = dateFormatter.stringFromDate(date!) + " " + (ticket["creator"] as? String)!
        
        accepted = ticket["accepted"] as? String
        assigned = ticket["assigned"] as? String
        assignee = ticket["assignee"] as? String
        completed = ticket["completed"] as? String
        priority = ticket["priority"] as? Int
        objectID = ticket.objectId
        
        if(assignee != "N"){
            assignButton.titleLabel?.text = "ASSIGNED To " + assignee
        } else {
            assignButton.titleLabel?.text = "ASSIGN"
        }
        
        populateDetailView()
    }
    
    func populateDetailView(){
        expandedHeight = compressedHeight
        
        // Create expanded information views
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM DD, YY, hh:mm"
        let stringFormatter = NSDateFormatter()
        stringFormatter.dateFormat = "hh:mm"
        let frame = CGRect(x: 0, y: 0 - singleLineHeight, width: detailView.bounds.width, height: singleLineHeight)
        
        if assigned != "N" {
            let date = dateFormatter.dateFromString(assigned)
            let status = stringFormatter.stringFromDate(date!) + " Assigned to " + assignee
            assignedStatusView = StatusInfoView(frame: frame, status: status, color: delegate.orange)
            detailView.addSubview(assignedStatusView)
            expandedHeight += assignedStatusView.bounds.height
        }
        
        if accepted != "N" {
            let date = dateFormatter.dateFromString(accepted)
            let status = stringFormatter.stringFromDate(date!) + " Accepted"
            acceptedStatusView = StatusInfoView(frame: frame, status: status, color: delegate.green)
            detailView.addSubview(acceptedStatusView)
            expandedHeight += acceptedStatusView.bounds.height
        }
        
        if completed != "N" {
            let date = dateFormatter.dateFromString(completed)
            let status = stringFormatter.stringFromDate(date!) + " Completed"
            completedStatusView = StatusInfoView(frame: frame, status: status, color: delegate.blue)
            detailView.addSubview(completedStatusView)
            expandedHeight += acceptedStatusView.bounds.height
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func toggleCellExpansion(){
        expanded = !expanded
        var height = compressedHeight
        
        if expanded {
            height = expandedHeight
        }
        detailViewHeight.constant = height
    }
    
    func animateCellExpansion(){

        if expanded {
            var addHeight:CGFloat = singleLineHeight
            
            if assigned != "N" {
                assignedStatusView.transform = CGAffineTransformMakeTranslation(0, addHeight)
                addHeight += singleLineHeight
            }
            if accepted != "N" {
                acceptedStatusView.transform = CGAffineTransformMakeTranslation(0, addHeight)
                addHeight += singleLineHeight
            }
            if completed != "N" {
                completedStatusView.transform = CGAffineTransformMakeTranslation(0, addHeight)
            }
        } else {
            if assigned != "N" {
                assignedStatusView.transform = CGAffineTransformMakeTranslation(0, 0)
            }
            if accepted != "N" {
                acceptedStatusView.transform = CGAffineTransformMakeTranslation(0, 0)
            }
            if completed != "N" {
                completedStatusView.transform = CGAffineTransformMakeTranslation(0, 0)
            }
        }
    }
    
}
