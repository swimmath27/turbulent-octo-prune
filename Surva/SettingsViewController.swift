//
//  DetailViewController.swift
//  Surva
//
//  Created by April on 9/12/15.
//  Copyright (c) 2015 Michael Lombardo. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var genderController: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!

    @IBAction func saveButton_Clicked(sender: AnyObject) {
        activityLoader.hidden = false;
        activityLoader.startAnimating()

        var currentUser: PFUser = PFUser.currentUser()!
        currentUser["Gender"] = genderController.selectedSegmentIndex == 0 ? "M" : "F"
        var userAgeString: String = ageTextField.text
        currentUser["Age"] = userAgeString.toInt()!

        currentUser.saveEventually()

        performSegueWithIdentifier("SavedSettings", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityLoader.hidden = true;
        activityLoader.hidesWhenStopped = true;
        var currentUser = PFUser.currentUser()

        genderController.selectedSegmentIndex = (currentUser!["Gender"] as! String) == "M" ? 0 : 1
        ageTextField.text = currentUser!["Age"].stringValue!


        // Do any additional setup after loading the view.
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
