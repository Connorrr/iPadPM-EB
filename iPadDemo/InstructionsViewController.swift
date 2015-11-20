//
//  InstructionsViewController.swift
//  iPadDemo
//
//  Created by Connor Reid on 18/11/2015.
//  Copyright © 2015 Connor Reid. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    // MARK:  Properties

    @IBOutlet weak var mainTextField: UITextView!
    
    //  MARK:  Instance Variables
    
    var viewCount = 0           //  times the view has been accessed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hey dudes geta load of this instructions view")
        
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("I Segue'd in my pants")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("....  Just gotta find this....  um view was it?")
        
        var htmlFName = ""
        
        viewCount++             // increment to tell which html file to use
        
        if (viewCount == 1){
            htmlFName = "LDEBPM-Instructions"
        }else if (viewCount == 2){
            htmlFName = "LDEBPM-Main"
        }else{
            htmlFName = "LDEBPM-Goodbye"
        }
        
        setText(htmlFName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  Functions
    
    func setText(fName:  String){
        let url = NSBundle.mainBundle().URLForResource(fName, withExtension: "html")!
        let opts = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType]
        var d : NSDictionary? = nil
        let s = try! NSAttributedString(URL: url, options: opts, documentAttributes: &d)
        self.mainTextField.attributedText = s
    }

}
