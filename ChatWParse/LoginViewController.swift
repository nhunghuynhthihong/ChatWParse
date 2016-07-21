//
//  LoginViewController.swift
//  ChatWParse
//
//  Created by Nhung Huynh on 7/18/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            fetchProfile()
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    // MARK: - Handle facebook login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        print("here")
        return true
    }

    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) in
            if error != nil {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        
        PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            guard let user = user else {
                self.displayMessage(error?.userInfo["error"] as! String)
                return
            }
            print("Logging in as \(user.username)")
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    
    @IBAction func onSignUp(sender: UIButton) {
        // Run a spinner to show a task in progress
        
        var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        
        spinner.startAnimating()
        
        var newUser = PFUser()
        newUser.username = emailTextField.text
        newUser.password = passwordTextField.text
        newUser.email = emailTextField.text
        
        newUser.signUpInBackgroundWithBlock { (succeeded, error) in
            // Stop the spinner
            spinner.stopAnimating()
            if let error = error {
                let errorString = error.userInfo["error"] as! String
                self.displayMessage(errorString)
            } else {
                // Hooray
                print("Sign up success")
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }
    
    func displayMessage(message:String) {
        let alertControl = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertControl.addAction(okAction)
        self.presentViewController(alertControl, animated: true, completion: nil)
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
