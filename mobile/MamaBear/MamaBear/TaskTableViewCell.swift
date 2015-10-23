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
    var cellDelegate: TaskCellDelegate!
    
    var red: UIColor = UIColor(red: 1.0, green: 0.404, blue: 0.404, alpha: 1.0) //#FF6767
    var orange: UIColor = UIColor(red: 1.0, green: 0.745, blue: 0.42, alpha: 1.0) //#FFBE6B
    var green: UIColor = UIColor(red: 0.549, green: 0.749, blue: 0.439, alpha: 1.0) //#8CBF70
    var blue: UIColor = UIColor(red: 0.502, green: 0.69, blue: 0.871, alpha: 1.0) //#80B0DE
    var grey: UIColor = UIColor(red: 0.357, green: 0.357, blue: 0.357, alpha: 1.0) //#5B5B5B
    
    var accepted : String!
    var assigned : String!
    var assignee : String!
    var completed : String!
    var objectID : String!
    
    var index: NSIndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func assignButtonPressed() {
        cellDelegate.assignTicket(index)
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
                
                self.cellDelegate.refreshTickets([self.index])
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
                
                self.cellDelegate.refreshTickets([self.index])
            }
        }

    }
    
    func customizeCell(type:String){
        primaryButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        
        switch(type) {
            case "acceptCell":
                primaryButton.backgroundColor = green
                primaryButton.setTitle("ACCEPT", forState: UIControlState.Normal)
                primaryButton.addTarget(self, action: "acceptButtonPressed", forControlEvents: .TouchUpInside)
                headerView.backgroundColor = orange
                titleLabel.textColor = orange
                typeImageView.image = UIImage(named: "icon_2")
                
                break;
            case "completeCell":
                primaryButton.backgroundColor = blue
                primaryButton.setTitle("COMPLETE", forState: UIControlState.Normal)
                primaryButton.addTarget(self, action: "completeButtonPressed", forControlEvents: .TouchUpInside)
                titleLabel.textColor = green
                headerView.backgroundColor = green
                typeImageView.image = UIImage(named: "icon_3")
                break;
            case "assignCell":
                primaryButton.backgroundColor = orange
                primaryButton.setTitle("ASSIGN", forState: UIControlState.Normal)
                primaryButton.addTarget(self, action: "assignButtonPressed", forControlEvents: .TouchUpInside)
                headerView.backgroundColor = red
                titleLabel.textColor = red
                typeImageView.image = UIImage(named: "icon_1")

                break;
        default:
            primaryButton.backgroundColor = grey
            primaryButton.enabled = false
            primaryButton.setTitle("COMPLETED", forState: UIControlState.Disabled)
            headerView.backgroundColor = blue
            titleLabel.textColor = blue
            typeImageView.image = UIImage(named: "icon_4")
            break;
        }
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
        
//        infoView.bounds.size = CGSizeMake(infoView.frame.width, infoView.frame.height*2)
        
        // Configure the view for the selected state
        
//        buttonFrame = CGRectMake(infoView.frame.origin.x, 0, infoView.bounds.width, 40)
        
//        if(assignee == currentUser){
//            if(accepted == "N" || accepted == nil){
//                acceptButton = UIButton(frame: buttonFrame)
//                acceptButton.addTarget(self, action: "acceptButtonPressed", forControlEvents: .TouchUpInside)
//                acceptButton.backgroundColor = green
//                acceptButton.titleLabel?.text = "Accept"
//                acceptButton.center = CGPointMake(acceptButton.center.x, infoView.frame.origin.y + infoView.frame.height + acceptButton.frame.height/2)
//                addSubview(acceptButton)
//            } else {
//                completeButton = UIButton(frame: buttonFrame)
//                completeButton.addTarget(self, action: "completeButtonPressed", forControlEvents: .TouchUpInside)
//                completeButton.backgroundColor = blue
//                completeButton.titleLabel?.text = "Complete"
//                completeButton.center = CGPointMake(completeButton.center.x, infoView.frame.origin.y + infoView.frame.height + completeButton.frame.height/2)
//                addSubview(completeButton)
//            }
//        } else if(completed == "N" || completed == nil){
//            
//            assignButton = UIButton(frame: buttonFrame)
//            assignButton.addTarget(self, action: "assignButtonPressed", forControlEvents: .TouchUpInside)
//            assignButton.backgroundColor = orange
//            assignButton.titleLabel?.text = "Assign"
//            assignButton.center = CGPointMake(assignButton.center.x, infoView.frame.origin.y + infoView.frame.height + assignButton.frame.height/2)
//            addSubview(assignButton)
//        } else {
//            
//        }

    }
    
}
