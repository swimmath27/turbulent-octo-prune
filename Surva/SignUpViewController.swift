//
//  SignUpViewController.swift
//  Surva
//
//  Created by Michael Lombardo on 9/12/15.
//  Copyright (c) 2015 Michael Lombardo. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderController: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func signUp(sender: AnyObject) {

        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )

        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)

    }


    func processSignUp() {

        var userEmailAddress = emailAddressTextField.text
        var userPassword = passwordTextField.text
        var userConfirmPw = confirmPasswordTextField.text
        if userPassword != userConfirmPw
        {
            self.messageLabel.text = "Passwords must match"
            return
        }
        var userGender = genderController.selectedSegmentIndex == 0 ? "M" : "F"
        var userAgeString: String = ageTextField.text
        if userAgeString.isEmpty
        {
            self.messageLabel.text = "Age must not be empty"
            return
        }
        var userAge = userAgeString.toInt()
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString

        // Add email address validation

        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()


        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        user["Gender"] = userGender
        if let age = userAge
        {
            user["Age"] = age
        }
        else
        {
            user["Age"] = 0
        }

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {

                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("SignUpSuccessful", sender: self)
                }

            } else {

                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true

                if let message: AnyObject = error!.userInfo!["error"] {
                    self.messageLabel.text = "\(message)"
                }
            }
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidden = true;
        activityIndicator.hidesWhenStopped = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    func keyboardNotification(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        /*
        var amt: CGFloat = 0.0
        if let responder = view.currentFirstResponder()
        {
        var bc : NSLayoutConstraint? = nil
        if responder == emailAddress
        {
        bc = bcEmail
        }
        else if responder == password
        {
        bc = bcPassword
        }
        amt = -bc!.constant + (keyboardFrame.size.height + 20);
        }


        var bottomConstraints = [bcEmail, bcLogo, bcPassword]

        for bc in bottomConstraints {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
        bc.constant += amt
        })
        }
        */

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
