//
//  ChatViewController.swift
//  ParseApp
//
//  Created by Richard Du on 2/5/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
   
    
    var messages: [PFObject]?
    var users: [PFObject]?
    
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        messageField.placeholder = "say something..."
        
        // construct PFQuery
        let messageQuery = PFQuery(className: "Message")
        messageQuery.order(byDescending: "createdAt")
        messageQuery.limit = 20
        
        // fetch data asynchronously
        messageQuery.findObjectsInBackground { (messages: [PFObject]?, error: Error?) -> Void in
            if let messages = messages {
                // do something with the data fetched
                self.messages = messages
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
        let userQuery = PFQuery(className: "_User")
        
        // fetch data asynchronously
        userQuery.findObjectsInBackground { (users: [PFObject]?, error: Error?) -> Void in
            if let users = users {
                // do something with the data fetched
                self.users = users
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }

        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSend(_ sender: AnyObject) {
        let parseMessage = PFObject(className: "Message")
        parseMessage.setObject(PFUser.current()!, forKey: "user")
        parseMessage["text"] = messageField.text
        
        parseMessage.saveInBackground { (success:Bool, error:Error?) in
            if success {
                print("Message was saved")
                self.messageField.text = ""
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    @IBAction func onLogout(_ sender: AnyObject) {
        PFUser.logOutInBackground { (error:Error?) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
            
            print("Logging out")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let messages = messages {
            return messages.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
        let message = messages?[indexPath.row]
        let text = message?["text"] as? String
        let textAuthor = message?.object(forKey: "user") as? PFUser
        
        cell.userLabel.text = nil //initially set to empty
        
        if let users = self.users {
            for user in users {
                if let textAuthor = textAuthor {
                    
                    if textAuthor.objectId == user.objectId {
                        cell.userLabel.text = user["username"] as? String
                    }
                }
            }
        }
        
        cell.textMessageLabel.text = text
        
        return cell
    }
    
    func onTimer() {
        // Add code to be run periodically
        
        let userQuery = PFQuery(className: "_User")
        userQuery.limit = 1000
        // fetch data asynchronously
        userQuery.findObjectsInBackground { (users: [PFObject]?, error: Error?) -> Void in
            if let users = users {
                // do something with the data fetched
                self.users = users
                print("USERS")
                print(users)
                self.tableView.reloadData()
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
        
        // construct PFQuery
        let messageQuery = PFQuery(className: "Message")
        messageQuery.order(byDescending: "createdAt")
        messageQuery.limit = 20
        
        messageQuery.findObjectsInBackground { (messages: [PFObject]?, error: Error?) -> Void in
            if let messages = messages {
                // do something with the data fetched
                
                self.messages = messages
                print("MESSAGES")
                print(messages)
                self.tableView.reloadData()
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
