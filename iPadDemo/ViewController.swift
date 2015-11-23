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
        print("Registered a little Tapperoonie!")
        if (timerOpen) {
            timerOpen = false
            masterTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }
    // TODO:  Make sure that button mashing doesn't fuck shit up
    @IBAction func wordButton(sender: UIButton) {
        trialTimer?.invalidate()
        userResponse = "L"
        threadStimEnd()
    }
    
    @IBAction func nonWordButton(sender: UIButton) {
        trialTimer?.invalidate()
        userResponse = "M"
        threadStimEnd()
    }
    
    @IBAction func animalWordButton(sender: UIButton) {
        trialTimer?.invalidate()
        userResponse = "R"
        threadStimEnd()
    }
    // MARK:  Instance Variables
    
    var timerCount : Int = 0
    let startTime = NSDate.timeIntervalSinceReferenceDate()
    var masterTimer : NSTimer!
    var trialTimer : NSTimer!
    var stimArray : [[String]] = []         // Stimulus Array. Types: 1 - Word, 2 - Non-word, 3 - PM
    var responseArray : [Response] = []
    var userResponse : String = "na"
    var trialStartTime : NSTimeInterval!
    var trialNumber : Int = 0
    var trialType : String = "Practice"     // Practice or Main
    var timerOpen : Bool = true
    var isPractice : Bool = true
    var viewCount = 0
    
    //  MARK:  Objects
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        importCSV()
        
        targetWord.text = stimArray[0][0]
        setTrialTimer()
        
        //updateTargetWord(stimArray[1].stim, withDelay: false)               // Set initial Stim
        trialStartTime = NSDate.timeIntervalSinceReferenceDate()    // Set first trial start time
        
        // TODO:  Make sure that this is invalidated with a button press
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if (!StaticVariables.isPractice){
            trialType = "Main"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (StaticVariables.isPractice){
            StaticVariables.isPractice = false
        }
    }
    
    func setTrialTimer() {
            self.trialTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "threadStimEnd", userInfo: nil, repeats: false)   //  After 3 seconds make sure the stim is removed
    }
    
    func threadStimEnd() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.stimEnd()
        }
    }
    
    func stimEnd() {
        //TODO:  MAKE SURE THAT YOU THREAD LOCK THIS FUNCTION!!!!!
        let trialEndTime = NSDate.timeIntervalSinceReferenceDate()
        var reactionTime = 0.0
        var corr = 0
        if (self.userResponse != "na"){     //Check if the user responded
            reactionTime = trialEndTime - self.trialStartTime               // Get reaction time
            if (self.stimArray[self.trialNumber][1] == self.userResponse){  //
                corr = 1
            }
        }
        
        // Check if response is correct or not
        
        let response = Response(trialType: self.trialType, stim: self.stimArray[self.trialNumber][0], response: self.userResponse, rt: reactionTime, corr: corr)
        
        self.userResponse = "na"        //  Reset response for trial timeout
        
        self.responseArray.append(response)
        
        self.trialNumber++              //incriment trial counter
        dispatch_sync(dispatch_get_main_queue()) {
            self.targetWord.text = " ";
        }
    
        if self.trialNumber < 3 {       //self.stimArray.count {
            NSThread.sleepForTimeInterval(NSTimeInterval(0.5))
            dispatch_sync(dispatch_get_main_queue()) {
                self.targetWord.text = self.stimArray[self.trialNumber][0]
                self.setTrialTimer()
                self.trialStartTime = NSDate.timeIntervalSinceReferenceDate()   // Set new trial start time
            }
        }else{
            //print("not true")
            structArrayToCSV(self.responseArray)
            dispatch_sync(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
        
        //TODO: This will need to be stored into an array for the log file
    }
    
    func structArrayToCSV(responses: [Response]) -> String{
        var returnCSVString : String = ""
        
        for response in responses {
            returnCSVString += response.trialType + "," + response.stim + "," + response.response + "," + String(response.rt) + "," + String(response.corr) + "\n"
        }
        
        saveCSV(returnCSVString)
        return returnCSVString
    }

    func updateTime() {
        
        //print("whats the time mister wolf hahah.... ok ill get back to work")
        
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
        //print("\(strMinutes):\(strSeconds)")
        
        if timerCount > 7 {
            timerCount = 0
            masterClock.text = ""
            masterTimer.invalidate()
            timerOpen = true
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
    
    func saveCSV(log: String) {
        let file = "log.csv" //this is the file. we will write to and read from it
        
        let text = log //just a text
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file);
            
            //writing
            do {
                try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {
                print("Um OK...  I don't want you to over react but...  someshitgotfuckedupwhiletryingtosavethatfile....K..bye...")
            }
            
            //reading
            do {
                let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                print(text2)
            }
            catch {/* error handling here */}
        }
    }

}

