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

    @IBOutlet weak var IV: UIImageView!

    var questions: [PFObject] = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
                if (self.questions.count > 0)
                {
                    //display first object
                    let pic = self.questions[0]["Picture"] as! PFFile

                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:      NSError?) -> Void in
                        if (error == nil) {
                            self.IV.image = UIImage(data:imageData!)
                        }
                    }
                }
                else
                {

                }
            } else {
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
