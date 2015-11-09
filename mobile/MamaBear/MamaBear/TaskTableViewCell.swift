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
    var buttonFrame: CGRect!
    
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
    
    let expandedHeight : CGFloat = 300.0
    let compressedHeight : CGFloat = 160.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func toggleCellExpansion(){
        expanded = !expanded
        var height = compressedHeight
        if expanded { height = expandedHeight }
        infoHeightConstraint.constant = height
    }
    
}
