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
    @IBOutlet var infoView: UIView!
    @IBOutlet var headerView: UIView!
    var assignButton: UIButton!
    var acceptButton: UIButton!
    var completeButton: UIButton!
    
    var assignedStatusView: StatusInfoView!
    var acceptedStatusView: StatusInfoView!
    var completedStatusView: StatusInfoView!
    
    @IBOutlet var primaryButton: UIButton!
    var delegate: TaskCellDelegate!
        
    var accepted : String!
    var assigned : String!
    var assignee : String!
    var completed : String!
    var objectID : String!
    
    var expanded : Bool = false
    var customized : Bool = false
    var index: NSIndexPath!
    var infoHeightConstraint: NSLayoutConstraint!
    
    let compressedHeight : CGFloat = 165.0
    var expandedHeight : CGFloat = 165.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create constraint to allow for expanding views
        autoresizingMask = UIViewAutoresizing.FlexibleHeight
        infoHeightConstraint = NSLayoutConstraint(item: infoView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: compressedHeight)
        infoHeightConstraint.priority = 999
        infoView.addConstraint(infoHeightConstraint)
        selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func assignButtonPressed() {
        delegate.assignTicket(index)
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
        if expanded { height = expandedHeight }
        
        infoHeightConstraint.constant = height
        
        primaryButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        contentView.backgroundColor = delegate.lightGrey
        
        switch(type) {
            case "acceptCell":
                primaryButton.backgroundColor = delegate.green
                primaryButton.setTitle("ACCEPT", forState: UIControlState.Normal)
                primaryButton.addTarget(self, action: "acceptButtonPressed", forControlEvents: .TouchUpInside)
                headerView.backgroundColor = delegate.orange
                titleLabel.textColor = delegate.orange
                typeImageView.image = UIImage(named: "icon_2")
                
                break;
            case "completeCell":
                primaryButton.backgroundColor = delegate.blue
                primaryButton.setTitle("CLOSE", forState: UIControlState.Normal)
                primaryButton.addTarget(self, action: "completeButtonPressed", forControlEvents: .TouchUpInside)
                titleLabel.textColor = delegate.green
                headerView.backgroundColor = delegate.green
                typeImageView.image = UIImage(named: "icon_3")
                break;
            case "assignCell":
                primaryButton.backgroundColor = delegate.orange
                primaryButton.setTitle("ASSIGN", forState: UIControlState.Normal)
                primaryButton.addTarget(self, action: "assignButtonPressed", forControlEvents: .TouchUpInside)
                headerView.backgroundColor = delegate.red
                titleLabel.textColor = delegate.red
                typeImageView.image = UIImage(named: "icon_1")

                break;
        default:
            primaryButton.backgroundColor = delegate.darkGrey
            primaryButton.enabled = false
            primaryButton.setTitle("COMPLETED", forState: UIControlState.Disabled)
            headerView.backgroundColor = delegate.blue
            titleLabel.textColor = delegate.blue
            typeImageView.image = UIImage(named: "icon_4")
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
        objectID = ticket.objectId
        
        populateInfoView()
    }
    
    func populateInfoView(){
        expandedHeight = compressedHeight
        
        // Create expanded information views
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM DD, YY, hh:mm"
        let stringFormatter = NSDateFormatter()
        stringFormatter.dateFormat = "hh:mm"
        let frame = CGRect(x: 0, y: compressedHeight, width: infoView.bounds.width, height: primaryButton.bounds.height)
        
        if assigned != "N" {
            let date = dateFormatter.dateFromString(assigned)
            let status = stringFormatter.stringFromDate(date!) + " Assigned to " + assignee
            assignedStatusView = StatusInfoView(frame: frame, status: status, color: delegate.orange)
//            let widthConstraint = 
//            assignedStatusView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
            infoView.addSubview(assignedStatusView)
            expandedHeight += assignedStatusView.bounds.height
        }
        
        if accepted != "N" {
            let date = dateFormatter.dateFromString(accepted)
            let status = stringFormatter.stringFromDate(date!) + " Accepted"
            acceptedStatusView = StatusInfoView(frame: frame, status: status, color: delegate.green)
            infoView.addSubview(acceptedStatusView)
            expandedHeight += acceptedStatusView.bounds.height
        }
        
        if completed != "N" {
            let date = dateFormatter.dateFromString(completed)
            let status = stringFormatter.stringFromDate(date!) + " Completed"
            completedStatusView = StatusInfoView(frame: frame, status: status, color: delegate.blue)
            infoView.addSubview(completedStatusView)
            primaryButton.alpha = 0.0
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
        infoHeightConstraint.constant = height
    }
    
    func animateCellExpansion(){
        if expanded {
            var addHeight:CGFloat = 0.0
            
            if assigned != "N" {
                addHeight += assignedStatusView.bounds.height
            }
            if accepted != "N" {
                acceptedStatusView.transform = CGAffineTransformMakeTranslation(0, addHeight)
                addHeight += acceptedStatusView.bounds.height
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
