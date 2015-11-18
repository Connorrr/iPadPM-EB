//
//  ViewController.swift
//  iPadDemo
//
//  Created by Connor Reid on 5/11/2015.
//  Copyright © 2015 Connor Reid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK:  Properties

    @IBOutlet weak var targetWord: UILabel!
    
    @IBOutlet weak var masterClock: UILabel!
    
    // MARK:  Actions
    
    @IBAction func tappedHeader(sender: AnyObject) {
        //print("Registered a little Tapperoonie!")
        
        masterTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        
    }
    
    @IBAction func wordButton(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.stimEnd()
        }
    }
    
    @IBAction func nonWordButton(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.stimEnd()
        }
    }
    
    @IBAction func animalWordButton(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.stimEnd()
        }
    }
    // MARK:  Class Level Variables
    
    var timerCount : Int = 0
    let startTime = NSDate.timeIntervalSinceReferenceDate()
    var masterTimer : NSTimer!
    var trialTimer : NSTimer!
    var stimArray : [[String]] = []    // Stimulus Array. Types: 1 - Word, 2 - Non-word, 3 - PM
    var trialStartTime : NSTimeInterval!
    var trialNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        importCSV()
        
        targetWord.text = stimArray[0][0]
        
        //updateTargetWord(stimArray[1].stim, withDelay: false)               // Set initial Stim
        trialStartTime = NSDate.timeIntervalSinceReferenceDate()    // Set first trial start time
            //trialTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "stimEnd", userInfo: nil, repeats: false)   //  After 3 seconds make sure the stim is removed
            // TODO:  Make sure that this is invalidated with a button press
        
    }
    
    func stimEnd() {
        let trialEndTime = NSDate.timeIntervalSinceReferenceDate()
        let reactionTime = trialEndTime - trialStartTime
        print(reactionTime)
        
        self.trialNumber++   //incriment trial counter
        dispatch_sync(dispatch_get_main_queue()) {
            self.targetWord.text = " ";
        }
        NSThread.sleepForTimeInterval(NSTimeInterval(0.5))
        dispatch_sync(dispatch_get_main_queue()) {
            self.targetWord.text = self.stimArray[self.trialNumber][0]
            self.trialStartTime = NSDate.timeIntervalSinceReferenceDate()   // Set new trial start time
        }
        
        //TODO: This will need to be stored into an array for the log file
        //sleep(0.5)  // Wait 500 milliseconds before starting a new trial
        
        //updateTargetWord(stimArray[trialNumber][0], withDelay: false)       // Display the new stim
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTime() {
        
        timerCount++    // Update timer count to stop at 8
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = Int(elapsedTime / 60.0)
        
        elapsedTime = elapsedTime - Double(minutes * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = Int(elapsedTime)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
    
        masterClock.text = "\(strMinutes):\(strSeconds)"
        
        if timerCount > 7 {
            timerCount = 0
            masterClock.text = ""
            masterTimer.invalidate()
        }
        
    }
    
    func importCSV() {
        let fileLocation = NSBundle.mainBundle().pathForResource("LDTPractice", ofType: "csv")!
        
        let error: NSErrorPointer = nil
        if let csv = CSV(contentsOfFile: fileLocation, error: error) {
            // Rows
            stimArray = csv.aRows
        }
        
        
    }

}

