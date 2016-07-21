//
//  ChatViewController.swift
//  ChatWParse
//
//  Created by Nhung Huynh on 7/18/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var dataMessage = [String]()
    var dataUser = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadMessages()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ChatViewController.loadMessages), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSend(sender: UIButton) {
        var message = PFObject(className: "Message_Swift_072016")
        message["text"] = messageTextField.text
        message["user"] = PFUser.currentUser()
        message.saveInBackgroundWithBlock { (success, error) in
            if success {
                print("Successfully post a text: \(message["text"]) and user: \(message["user"])")
                self.loadMessages()
            } else {
                print("Fail for post text: \(error)")
            }
        }
    }
    
    func loadMessages() {
        
        var query = PFQuery(className: "Message_Swift_072016")
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                print("Successfully retrieve \(objects?.count) scores")
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        var text = object["text"] as? String
                        let pfUser = object["user"] as? PFUser
                        print("user \(pfUser)")
                        if pfUser != nil {
                            print("retrieved related post: \(text) and user: \(pfUser?.username)")
                            self.dataUser.append(pfUser!.username!)
                            self.dataMessage.append(text ?? "")
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                print("Error: \(error) \(error?.userInfo)")
            }
            
        }
    }
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        print("Before logout \(PFUser.currentUser())")
        PFUser.logOut()
        print("After logout \(PFUser.currentUser())")
        self.performSegueWithIdentifier("logoutSegue", sender: self)
        
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
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataMessage.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ChatTableViewCell
        cell.usernameLaebel.text = dataUser[indexPath.row]
        cell.messageLabel.text = dataMessage[indexPath.row]
        return cell
    }
}
