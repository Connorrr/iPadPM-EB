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
    
    @IBOutlet weak var wordButtonOutlet: UIButton!
    
    @IBOutlet weak var nonWordButtonOutlet: UIButton!
    
    @IBOutlet weak var animalWordButtonOutlet: UIButton!
    
    
    // MARK:  Actions
    
    @IBAction func tappedHeader(sender: AnyObject) {
        print("Registered a little Tapperoonie!")
        if (timerOpen) {
            timerOpen = false
            updateTime()
            masterTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }

    @IBAction func wordButton(sender: UIButton) {
        trialTimer?.invalidate()
        disableButtons()
        userResponse = "L"
        threadStimEnd()
    }
    
    @IBAction func nonWordButton(sender: UIButton) {
        trialTimer?.invalidate()
        disableButtons()
        userResponse = "M"
        threadStimEnd()
    }
    
    @IBAction func animalWordButton(sender: UIButton) {
        trialTimer?.invalidate()
        disableButtons()
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
    var trialNumber : Int = 0
    var trialType : String = "Practice"     // Practice or Main
    var timerOpen : Bool = true
    var isPractice : Bool = true
    var viewCount = 0
    
    //  MARK:  SuperClass functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        importCSV()                             // Get input CSV file
        
        targetWord.text = stimArray[0][0].uppercaseString       // Set the intiial Stimulus
        setTrialTimer()                         // Set initial trial timer
        
        if (isPractice) {                       //  If this is the first runthrough.  Set the start time.
            StaticVariables.trialsStartTime = NSDate.timeIntervalSinceReferenceDate()    // Set first trial start time
        }
        
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
        }else{
            saveCSV(StaticVariables.csvString)
        }
    }
    
    // MARK:  Functions
    
    func setTrialTimer() {
            self.trialTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "threadStimEnd", userInfo: nil, repeats: false)   //  After 3 seconds make sure the stim is removed
    }
    
    func threadStimEnd() {
        disableButtons()
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
            reactionTime = trialEndTime - StaticVariables.trialsStartTime               // Get reaction time
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
    
        if self.trialNumber < self.stimArray.count {
            NSThread.sleepForTimeInterval(NSTimeInterval(1.0))
            dispatch_sync(dispatch_get_main_queue()) {
                self.targetWord.text = self.stimArray[self.trialNumber][0].uppercaseString
                self.enableButtons()
                self.setTrialTimer()
                StaticVariables.trialsStartTime = NSDate.timeIntervalSinceReferenceDate()   // Set new trial start time
            }
        }else{
            StaticVariables.csvString += structArrayToCSV(self.responseArray)
            dispatch_sync(dispatch_get_main_queue()) {
                if (StaticVariables.isPractice){
                    self.dismissViewControllerAnimated(true, completion: nil);
                }else{      //go to goodbyeSegue if finished
                    self.performSegueWithIdentifier("goodbyeSegue", sender: nil)
                }
                
            }
        }
        
    }
    
    func structArrayToCSV(responses: [Response]) -> String{
        var returnCSVString : String = ""
        
        for response in responses {
            returnCSVString += response.trialType + "," + response.stim + "," + response.response + "," + String(response.rt) + "," + String(response.corr) + "\n"
        }
        
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
        var fileLocation : String
        if (StaticVariables.isPractice){
            fileLocation = NSBundle.mainBundle().pathForResource("LDTPractice", ofType: "csv")!
        }else{
            fileLocation = NSBundle.mainBundle().pathForResource("LDTMain", ofType: "csv")!
        }
        
        let error: NSErrorPointer = nil
        if let csv = CSV(contentsOfFile: fileLocation, error: error) {
            // Rows
            stimArray = csv.aRows
        }
    }
    
    func saveCSV(log: String) {
        let file = StaticVariables.participant + "_log.csv" //this is the file. we will write to and read from it
        
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
    
    func enableButtons() {
        wordButtonOutlet.enabled = true
        nonWordButtonOutlet.enabled = true
        animalWordButtonOutlet.enabled = true
    }
    
    func disableButtons() {
        wordButtonOutlet.enabled = false
        nonWordButtonOutlet.enabled = false
        animalWordButtonOutlet.enabled = false
    }

}

