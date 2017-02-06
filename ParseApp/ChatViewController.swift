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
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("_p_User")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) -> Void in
            if let messages = messages {
                // do something with the data fetched
                self.messages = messages
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        let query2 = PFQuery(className: "_User")
    
        
        // fetch data asynchronously
        query2.findObjectsInBackground { (users: [PFObject]?, error: Error?) -> Void in
            if let users = users {
                // do something with the data fetched
                self.users = users
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }

        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSend(_ sender: AnyObject) {
        let parseMessage = PFObject(className: "Message")
        parseMessage.setObject(PFUser.current(), forKey: "User")
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
        let textAuthor = message?.object(forKey: "User") as! PFUser
        
        if let users = self.users {
            
            for user in users {
                if textAuthor.objectId == user.objectId {
                    cell.userLabel.text = user["username"] as? String
                }
            }
        }
        
        cell.textMessageLabel.text = text
        
        return cell
    }
    
    func onTimer() {
        // Add code to be run periodically
        
        // construct PFQuery
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("_p_User")
        query.limit = 20
        
        let query2 = PFQuery(className: "_User")
        
        // fetch data asynchronously
        query2.findObjectsInBackground { (users: [PFObject]?, error: Error?) -> Void in
            if let users = users {
                // do something with the data fetched
                self.users = users
                
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) -> Void in
            if let messages = messages {
                // do something with the data fetched
                
                self.messages = messages
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
