//
//  LoginViewController.swift
//  MamaBear
//
//  Created by Brandon Plaster on 10/23/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var userTypeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("tickets", forKey: "channels")
        currentInstallation.saveInBackground()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func enterButtonPressed(sender: AnyObject) {
        let taskView = TicketListViewController()
        taskView.currentUserType = userTypeTextField.text!
        taskView.currentUser = usernameTextField.text!
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        navigationController?.pushViewController(taskView, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        }
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
