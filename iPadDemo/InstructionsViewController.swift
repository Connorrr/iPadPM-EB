//
//  InstructionsViewController.swift
//  iPadDemo
//
//  Created by Connor Reid on 18/11/2015.
//  Copyright © 2015 Connor Reid. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var mainTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("LDEBPM-Instructions", withExtension: "html")!
        let opts = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType]
        var d : NSDictionary? = nil
        let s = try! NSAttributedString(URL: url, options: opts, documentAttributes: &d)
        self.mainTextField.attributedText = s

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
