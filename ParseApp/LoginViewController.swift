//
//  LoginViewController.swift
//  ParseApp
//
//  Created by Richard Du on 2/5/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSignup(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Error", message: "Username is already taken.", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        
        let newUser = PFUser()
        
        newUser.username = emailField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if success {
                print("Yay, a new user was created")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
        
    }
    
    
    @IBAction func onLogin(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Access Denied", message: "Invalid username or password.", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        
        PFUser.logInWithUsername(inBackground: emailField.text!, password: passwordField.text!) { (user: PFUser?, error:Error?) in
            if user != nil {
                print("You're logged in")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
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
