//
//  QuestionViewController.swift
//  Surva
//
//  Created by April on 9/12/15.
//  Copyright (c) 2015 Michael Lombardo. All rights reserved.
//

import UIKit
import Parse

class QuestionViewController: UIViewController {
    
    var currentObject: PFObject?
    var currentpos: Int = 0

    @IBOutlet weak var IV: UIImageView!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    var questions: [PFObject] = [PFObject]()
    var questionImages: [UIImage] = [UIImage]()

    //from "matt" on stackoverflow
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    @IBAction func answerYes(sender: AnyObject)
    {
        SwipeRight()
    }
    @IBAction func SwipeRight(sender: UISwipeGestureRecognizer)
    {
        SwipeRight()
    }
    func SwipeRight()
    {
        UIView.animateWithDuration(1) {
            self.IV.center = CGPointMake(self.IV.center.x + 3000, self.IV.center.y )
        }
        //other things after acception
        var response = PFObject(className: "Responses")
        response["questionID"] = self.questions[currentpos].objectId!
        response["userID"] = PFUser.currentUser()!.objectId!
        response["Response"] = true
        response.saveEventually()

        //make sure this happens after animation
        delay(1) {
            if self.currentpos < self.questionImages.count - 1
            {
                self.IV.image = self.questionImages[++self.currentpos]
                self.IV.center = CGPointMake(self.IV.center.x - 3000, self.IV.center.y )
            }
            else
            {
                self.IV.hidden = true;
                self.doneButton.hidden = false;
                var complete = PFObject(className: "Completed")
                complete["userID"] = PFUser.currentUser()!.objectId!
                complete["categoryID"] = self.currentObject!.objectId!
                complete.saveEventually()
            }
        }


    }


    @IBAction func answerNo(sender: AnyObject)
    {
        SwipeLeft()
    }
    @IBAction func SwipeLeft(sender: UISwipeGestureRecognizer)
    {
        SwipeLeft()
    }
    func SwipeLeft()
    {
        UIView.animateWithDuration(1) {
            self.IV.center = CGPointMake(self.IV.center.x - 3000, self.IV.center.y )
        }
        //other things after acception
        var response = PFObject(className: "Responses")
        response["questionID"] = self.questions[currentpos].objectId!
        response["userID"] = PFUser.currentUser()!.objectId!
        response["Response"] = false
        response.saveEventually()

        //make sure this happens after animation
        delay(1) {
            if self.currentpos < self.questionImages.count - 1
            {
                self.IV.image = self.questionImages[++self.currentpos]
                self.IV.center = CGPointMake(self.IV.center.x + 3000, self.IV.center.y )
            }
            else
            {
                self.IV.hidden = true;
                self.doneButton.hidden = false;
                var complete = PFObject(className: "Completed")
                complete["userID"] = PFUser.currentUser()!.objectId!
                complete["categoryID"] = self.currentObject!.objectId!
                complete.saveEventually()
            }
        }
        

        //other things after rejection
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("SwipeLeft:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("SwipeRight:"))

        leftSwipe.direction = .Left
        rightSwipe.direction = .Right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        QuestionLabel.text? = currentObject?["Question"] as! String

        var query = PFQuery(className: "Question")
        query.whereKey("CategoryID", equalTo: currentObject!.objectId!)


        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in

            if error == nil {
                // The find succeeded.

                // put found objects into array
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.questions.append(object)
                    }
                }
                for question in self.questions
                {
                    let pic = question["Picture"] as! PFFile

                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:      NSError?) -> Void in
                        if (error == nil) {
                            var UII = UIImage(data:imageData!)
                            if (self.questionImages.count == 0)
                            {
                                self.IV.image = UII;
                            }
                            self.questionImages.append(UII!)
                        }
                    }
                }
            }
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }


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
