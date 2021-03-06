//
//  ViewController.swift
//  SnapChat
//
//  Created by Peter Menner on 5/22/15.
//  Copyright (c) 2015 Peter Menner. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var formActionControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func formActionSelected(sender: UISegmentedControl) {
        formAction = sender.selectedSegmentIndex == 0 ? .Register : .Login
        changeFormAction()
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        
        errorMessage.text = ""
        switch formAction {
        case .Register:
            if usernameField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
                errorMessage.text = "All fields must be filled in"
                return
            } else if passwordField.text != confirmPasswordField.text {
                errorMessage.text = "Passwords must match"
            } else {
                // attempt to register user
                var user = PFUser()
                user.username = usernameField.text
                user.password = passwordField.text
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    if error != nil {
                        // there was a problem
                        println(error)
                        if let errorString = error?.userInfo?["error"] as? String {
                            self.errorMessage.text = errorString
                        }
                    } else {
                        // user registered successfully
                        println("user successfully created")
                        self.performSegueWithIdentifier("LoginSuccess", sender: self)
                    }
                })
            }
            break
        case .Login:
            if usernameField.text == "" || passwordField.text == "" {
                errorMessage.text = "All fields must be filled in"
                return
            } else {
                // attempt to log in user
                PFUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text, block: { (user, error) -> Void in
                    if user != nil {
                        println("user successfully logged in")
                        self.performSegueWithIdentifier("LoginSuccess", sender: self)
                    } else {
                        if let errorMessage = error?.userInfo?["error"] as? String {
                            self.errorMessage.text = errorMessage
                        }
                    }
                })
            }
            break
        }
    }
    
    enum formActionType: Int {
        case Register = 0, Login
    }
    
    var formAction: formActionType = .Register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        formAction = .Register
        changeFormAction()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let user = PFUser.currentUser() {
            println("user has session")
            performSegueWithIdentifier("LoginSuccess", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeFormAction() {
        switch formAction {
            case .Register:
                formActionControl.selectedSegmentIndex = 0
                confirmPasswordField.alpha = 1
                actionButton.setTitle("Register", forState: .Normal)
                break
            case .Login:
                formActionControl.selectedSegmentIndex = 1
                confirmPasswordField.alpha = 0
                actionButton.setTitle("Login", forState: .Normal)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

