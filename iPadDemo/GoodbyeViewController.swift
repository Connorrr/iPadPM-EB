//
//  GoodbyeViewController.swift
//  LDTPM
//
//  Created by Connor Reid on 18/04/2016.
//  Copyright © 2016 Connor Reid. All rights reserved.
//

import UIKit

class GoodbyeViewController: UIViewController {
    
    func postToServerFunction(_ csvString: String, fName: String, pId: String){
        print("Attempting to post beep..dd...beeep..beep")
        
        /*//csvlog , subid
        let request = NSMutableURLRequest(url: URL(string: "http://griffithpsychapps.com/iOS/LDTPM/save_file.php")!)
        //var session = NSURLSession.sharedSession()
        request.httpMethod = "POST"
        
        // Compose a query string
        let postString = "csvlog=\(csvString)&subid=" + fName + "_" + pId
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString)")
            
            //Let’s convert response sent from a server side script to a NSDictionary object:
            
        }) 
        
        task.resume()*/
        
        //  This section has been removed to improve Crash Rate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //postToServerFunction(StaticVariables.csvString, fName: "Responses", pId: StaticVariables.participant)
        //postToServerFunction(StaticVariables.csvTBTString, fName: "TBT", pId: StaticVariables.participant)
        //postToServerFunction(StaticVariables.csvButtonPressString, fName: "Buttons", pId: StaticVariables.participant)
        
        Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.endTrials), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func endTrials(){
        exit(1)
    }

}
