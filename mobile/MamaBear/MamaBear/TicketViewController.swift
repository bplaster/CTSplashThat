//
//  TicketViewController.swift
//  MamaBear
//
//  Created by Brandon Plaster on 10/22/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit
import Parse

class TicketViewController: UIViewController, AssignViewDelegate {

    @IBOutlet var titleTextField: UITextView!
    @IBOutlet var descTextField: UITextView!
    @IBOutlet var assignButton: UIButton!
    var currentUserType : String!
    var users: [PFObject] = []
    var creator: String = ""
    var assignee: String = "N"
    var assigned: String = "N"
    var assignView: AssignView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(currentUserType == "manager"){
            assignButton.enabled = true
            assignButton.alpha = 1.0
        } else {
            assignButton.enabled = false
            assignButton.alpha = 0.0
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func assignButtonPressed(sender: AnyObject) {
        assignView = AssignView(frame: view.frame)
        assignView.delegate = self
        assignView.staffList = users
        view.addSubview(assignView)
        
        assignView.bringUp(nil)
    }
    
    func dismissAssignView(index: NSIndexPath?) {
        if(assignView != nil){
            assignView.removeFromSuperview()
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM dd, yy, hh:mm"
            assigned = dateFormatter.stringFromDate(date)
            assignButton.setTitle("ASSIGN : " + assignee, forState: UIControlState.Normal)
        }
    }

   
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        let ticket = PFObject(className:"Ticket")
        ticket["title"] = titleTextField.text
        ticket["description"] = descTextField.text
        ticket["creator"] = creator
        ticket["assignee"] = assignee
        ticket["accepted"] = "N"
        ticket["assigned"] = "N"
        ticket["completed"] = "N"
        
        ticket.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Saved!")
                self.dismissViewControllerAnimated(true, completion: nil)
                // The object has been saved.
            } else {
                print(error?.description)
                // There was a problem, check error.description
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
