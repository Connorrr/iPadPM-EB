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
    
    @IBAction func startVersionBButtonPressed(_ sender: UIButton) {
        StaticVariables.version = "B"
        beginTrials()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        StaticVariables.version = "A"
        beginTrials()
    }
    
    func beginTrials(){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
            if (self.idField.text == ""){     //  id field empty
                //print("There was no text for me")
                let alert = UIAlertController(title: nil, message: "Please enter ID before you continue.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.default, handler: nil))
                DispatchQueue.main.sync{
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                StaticVariables.participant = self.idField.text!
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "startSegue", sender: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print(StaticVariables.participant)
    }

}
