//
//  TicketViewController.swift
//  MamaBear
//
//  Created by Brandon Plaster on 10/22/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit
import Parse

class TicketViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    @IBOutlet var assigneeTextField: UITextField!
    var creator: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        let ticket = PFObject(className:"Ticket")
        ticket["title"] = titleTextField.text
        ticket["description"] = descTextField.text
        ticket["creator"] = creator
        ticket["assignee"] = "N"
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
