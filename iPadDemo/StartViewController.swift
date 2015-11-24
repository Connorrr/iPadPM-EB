//
//  StartViewController.swift
//  iPadDemo
//
//  Created by Connor Reid on 24/11/2015.
//  Copyright © 2015 Connor Reid. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var idField: UITextField!
    
    @IBAction func startButtonPressed(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            if (self.idField.text == ""){     //  id field empty
                //print("There was no text for me")
                let alert = UIAlertController(title: nil, message: "Please enter ID before you continue.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                //print("There was some text for me, it was: \(self.idField.text)")
                StaticVariables.participant = self.idField.text!
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("startSegue", sender: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        //print(StaticVariables.participant)
    }

}
