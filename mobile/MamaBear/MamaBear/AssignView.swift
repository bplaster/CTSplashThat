//
//  AssignView.swift
//  MamaBear
//
//  Created by Brandon Plaster on 10/23/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit
import Parse

class AssignView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{

    var assigneeTableView: UITableView!
    var staffList: [PFObject] = []
    var objectID: String!
    var indexPath: NSIndexPath!
    var delegate: AssignViewDelegate!
    var availability: [Bool]!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        assigneeTableView = UITableView(frame: CGRectMake(frame.origin.x, frame.height, frame.width, 2.0*frame.height/3.0))
        assigneeTableView.delegate = self
        assigneeTableView.dataSource = self
        assigneeTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissView")
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        addSubview(assigneeTableView)
        self.alpha = 0.0
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isDescendantOfView(assigneeTableView){
            return false
        }
        return true
    }
    
    func dismissView(){
        putDown(nil)
    }
    
    func bringUp (index: NSIndexPath?) {
        self.indexPath = index
        UIView.animateWithDuration(0.4,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.alpha = 1.0
                self.assigneeTableView.center = CGPointMake(self.center.x, 2.0*self.frame.height/3.0)
            }, completion: nil)
    }
    
    
    func putDown (index: NSIndexPath?) {
        UIView.animateWithDuration(0.4,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.alpha = 0.0
                self.assigneeTableView.center = CGPoint(x:self.center.x , y: self.center.y + self.assigneeTableView.bounds.height/2)
            }, completion: { finished in self.delegate.dismissAssignView(index)} )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("StaffCell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "StaffCell")
        }
        
        var label = ""
        if let role = staffList[indexPath.row]["role"] as? String {
            label += role + " : "
        }
        
        if let username = staffList[indexPath.row]["username"] as? String {
            label += username
        }
        
        cell?.textLabel?.text = label
        let height:CGFloat = 10.0
        let xVal = cell!.contentView.bounds.width + 2*height
        let yVal = cell!.contentView.center.y - height/2
        let statusView = UIView(frame: CGRect(x: xVal, y: yVal, width: height, height: height))
        statusView.layer.cornerRadius = height/2
        
        if availability[indexPath.row] {
            statusView.backgroundColor = UIColor.greenColor()
        } else {
            statusView.backgroundColor = UIColor.redColor()
        }
        cell?.addSubview(statusView)
        
        return cell!
    }
    
    
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let username = staffList[indexPath.row]["username"] as? String
        self.delegate.assignee = username!
        self.putDown(self.indexPath)
    }

}
