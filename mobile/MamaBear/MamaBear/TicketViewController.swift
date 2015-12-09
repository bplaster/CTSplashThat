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


    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    @IBOutlet var assignButton: UIButton!
    var delegate: TicketViewDelegate!
    var currentUserType : String!
    var users: [PFObject] = []
    var availability: [Bool]!
    var creator: String = ""
    var assignee: String = "N"
    var assigned: String = "N"
    var assignView: AssignView!
    var priority: Int = 2
    let priorityTitle1 = "TODO"
    let priorityTitle2 = "Task"
    let priorityTitle3 = "Emergency"
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var dividerCenter: NSLayoutConstraint!
    
    @IBOutlet var priorityButton1: UIButton!
    @IBOutlet var priorityButton2: UIButton!
    @IBOutlet var priorityButton3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize textViews
//        let paddingView1 = UIView(frame: CGRectMake(0, 0, 5, titleTextField.frame.height))
//        titleTextField.leftView = paddingView1
//        titleTextField.leftViewMode = UITextFieldViewMode.Always
//        let paddingView2 = UIView(frame: CGRectMake(0, 0, 5, descTextField.frame.height))
//        descTextField.leftView = paddingView2
//        descTextField.leftViewMode = UITextFieldViewMode.Always
        
        let priorityButtonRadius = priorityButton1.bounds.width/2.0
        priorityButton1.layer.cornerRadius = priorityButtonRadius
        priorityButton2.layer.cornerRadius = priorityButtonRadius
        priorityButton3.layer.cornerRadius = priorityButtonRadius

        if(currentUserType == "manager"){
            assignButton.enabled = true
            assignButton.alpha = 1.0
            dividerCenter.constant = 0.0
        } else {
            assignButton.enabled = false
            assignButton.alpha = 0.0
            submitButton.contentEdgeInsets.left = -30.0
            dividerCenter.constant = -assignButton.bounds.width/2
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.navigationController?.navigationBar.barTintColor = self.priorityButton2.backgroundColor
            self.navigationItem.title  = self.priorityTitle2
        }
    }
    
    @IBAction func assignButtonPressed(sender: AnyObject) {
        assignView = AssignView(frame: view.frame)
        assignView.delegate = self
        assignView.staffList = delegate.users
        assignView.availability = availability
        view.addSubview(assignView)
        
        assignView.bringUp(nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    

    @IBAction func priorityButtonPressed(sender: AnyObject) {
        let button = sender as! UIButton
        var titleText = ""
        switch (button){
        case priorityButton1:
            priority = 1
            titleText = self.priorityTitle1
            break
        case priorityButton2:
            priority = 2
            titleText = self.priorityTitle2
            break
        case priorityButton3:
            priority = 3
            titleText = self.priorityTitle3
            break
        default:
            break
        }
        UIView.animateWithDuration(0.2) { () -> Void in
            self.navigationController?.navigationBar.barTintColor = button.backgroundColor
            self.navigationItem.title = titleText
        }

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
        ticket["assigned"] = assigned
        ticket["accepted"] = "N"
        ticket["completed"] = "N"
        ticket["priority"] = priority
        
        ticket.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Saved!")
                self.navigationController?.popViewControllerAnimated(true)
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
