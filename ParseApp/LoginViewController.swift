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
        let newUser = PFUser()
        
        newUser.username = emailField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if success {
                print("Yay, a new user was created")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                
            }
        }
    }
    
    
    @IBAction func onLogin(_ sender: AnyObject) {
        PFUser.logInWithUsername(inBackground: emailField.text!, password: passwordField.text!) { (user: PFUser?, error:Error?) in
            if user != nil {
                print("You're logged in")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
