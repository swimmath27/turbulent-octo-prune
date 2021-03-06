//
//  SignUpInViewController.swift
//  Surva
//
//  Created by Michael Lombardo on 9/12/15.
//  Copyright (c) 2015 Michael Lombardo. All rights reserved.
//

import UIKit
import Parse

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder()
        {
            return self
        }
        for view in self.subviews
        {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
class SignUpInViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var emailAddress: UITextField!
	@IBOutlet weak var password: UITextField!

	
	@IBAction func signIn(sender: AnyObject) {

        activityIndicator.hidden = false
        activityIndicator.startAnimating()

        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress.lowercaseString

        var userPassword = password.text

        PFUser.logInWithUsernameInBackground(userEmailAddress, password:userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.message.text = "\(message)"
                }
            }
        }
	}

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        emailAddress.resignFirstResponder()
        password.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)


        // Do any additional setup after loading the view.
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
