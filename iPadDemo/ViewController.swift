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
    
    @IBOutlet weak var bannerView: UIView!
    
    // MARK:  Images
    
    let buttonImage = UIImage(named: "button_blue_true")
    
    // MARK:  Actions
    
    @IBAction func tappedHeader(_ sender: AnyObject) {
        print("Registered a little Tapperoonie!")
        let time = Date.timeIntervalSinceReferenceDate - startTime
        StaticVariables.buttonPresses.append(ButtonAndTime(button: "H", time: time))
        getMScores()
        if (timerOpen) {
            timerOpen = false
            updateTime()
            masterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
            
        }
    }

    @IBAction func wordButton(_ sender: UIButton) {
        if(trialTimerOpen){
            let time = Date.timeIntervalSinceReferenceDate - startTime
            StaticVariables.buttonPresses.append(ButtonAndTime(button: "L", time: time))
            trialTimerOpen = false
            trialTimer!.invalidate()
            disableButtons()
            userResponse = "L"
            threadStimEnd()
        }
    }
    
    @IBAction func nonWordButton(_ sender: UIButton) {
        if(trialTimerOpen){
            let time = Date.timeIntervalSinceReferenceDate - startTime
            StaticVariables.buttonPresses.append(ButtonAndTime(button: "M", time: time))
            trialTimerOpen = false
            trialTimer!.invalidate()
            disableButtons()
            userResponse = "M"
            threadStimEnd()
        }
    }
    
    @IBAction func animalWordButton(_ sender: UIButton) {
        if(trialTimerOpen){
            let time = Date.timeIntervalSinceReferenceDate - startTime
            StaticVariables.buttonPresses.append(ButtonAndTime(button: "R", time: time))
            if (StaticVariables.currentTask != Task.tbt){
                trialTimer!.invalidate()
                disableButtons()
            }
            userResponse = "R"
            threadStimEnd()
        }
    }
    // MARK:  Instance Variables
    
    var timerCount : Int = 0
    let startTime = Date.timeIntervalSinceReferenceDate
    var masterTimer : Timer!
    var trialTimer : Timer!
    var TBTTimer : Timer?
    var stimArray : [[String]] = []         // Stimulus Array. Types: 1 - Word, 2 - Non-word
    var userResponse : String = "na"
    var trialNumber : Int = 0
    var trialType : String = "Practice"     // Practice or Main
    var timerOpen : Bool = true
    var trialTimerOpen: Bool = true         // Used to make sure that button mashing doesn't SCREW ERRY THNG URRRP
    var numberOfTrials = 8
    var score = 0
    var trialsStartTime = Date.timeIntervalSinceReferenceDate
    var tbtReturn = LockAndScore(lockout: TimeInterval(0.0), score: 0)
    var timeButtonPresses = 0       //  Number of times the Time button is pressed in the TBT trials
    var TBTResponse : [[String]] = []
    var mCheckCount : [[Int]] = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]      //  Used for M Scores
    var isTimeToEnd : Bool = false          //  Used to end TBT trials once timer finishes
    var currentPM = 0                       //  Used to figure out which PM cue we are at
    
    //  MARK:  Classes, Structs and Enums
    
    //  MARK:  SuperClass functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded Trial View")
        // Do any additional setup after loading the view, typically from a nib.
        importCSV()                                                  // Get input CSV file
        
        numberOfTrials = stimArray.count
        
        targetWord.text = stimArray[0][0].uppercased()            // Set the intiial Stimulus
        setTrialTimer()                                              // Set initial trial timer
        
        trialsStartTime = Date.timeIntervalSinceReferenceDate    // Set first trial start time
        print("Made it to the end of ViewController ViewDidLoad")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpTrial()
        if (StaticVariables.isPractice && StaticVariables.currentTask == Task.ldt){
            print("Started with practices")
        }else if(StaticVariables.isPractice && StaticVariables.currentTask == Task.tbt){
            animalWordButtonOutlet.setTitle("Time", for: UIControlState())
        }else{
            addButtonImages()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Score for this round is \(score)")
        currentPM = 0           //  Reset Current PM
        if (StaticVariables.isPractice){
            StaticVariables.isPractice = false
            if (StaticVariables.currentTask == Task.ldt){
                StaticVariables.currentTask = Task.ebt  //  Go to EBT
            }
            if (StaticVariables.currentTask == Task.tbt){
                StaticVariables.csvTBTString += TBTArrayToCsvString(score, mChecks: mCheckCount)
            }
        }else{
            switch StaticVariables.currentTask {
            case .ldt:
                StaticVariables.currentTask = Task.ebt
            case .ebt:
                StaticVariables.currentTask = Task.tbt
                StaticVariables.isPractice = true
            case .tbt:
                StaticVariables.currentTask = Task.done
                saveCSV(structArrayToCSV(StaticVariables.responseArray), fName: "Results")
                StaticVariables.csvTBTString += TBTArrayToCsvString(score, mChecks: mCheckCount)
                saveCSV(StaticVariables.csvTBTString, fName: "TBT")
                StaticVariables.csvButtonPressString += buttonArrayToCSV(StaticVariables.buttonPresses)
                saveCSV(StaticVariables.csvButtonPressString, fName: "ButtonPresses")
            default:
                print("Error in View will disappear switch Statement")
                break
            }
        }
        score = 0
    }
    
    // MARK:  Functions
    
    func setUpTrial(){
        if (StaticVariables.currentTask == Task.ldt){
            bannerView.isHidden = true
        }else if(StaticVariables.currentTask == Task.ebt){
            bannerView.isHidden = true
        }else if(StaticVariables.currentTask == Task.tbt){
            bannerView.isHidden = false
            if (StaticVariables.isPractice){
                print("Set Practice TBT Timer")
                self.TBTTimer = Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(self.endTBTTrials), userInfo: nil, repeats: false)
            }else{
                print("Set Main TBT Timer")
                self.TBTTimer = Timer.scheduledTimer(timeInterval: 390.0, target: self, selector: #selector(self.endTBTTrials), userInfo: nil, repeats: false)
            }
        }
    }
    
    //  Used to end the TBT trials once time limit is reached
    @objc func endTBTTrials(){
        print("TBT Timer function called")
        self.isTimeToEnd = true
    }
    
    func setTrialTimer() {
            self.trialTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.timerStimEnd), userInfo: nil, repeats: false)   //  After 3 seconds make sure the stim is removed
    }
    
    @objc func timerStimEnd(){
        self.targetWord.text = " "
    }
    
    func checkScore() -> Bool{
        var isPassable = true // If it is a R response in TBT dont end yet
        if (self.userResponse == "R"){
            if (StaticVariables.currentTask == Task.tbt){
                isPassable = false
                timeButtonPresses += 1
                let currentTime = Date.timeIntervalSinceReferenceDate
                let elapsedTime = currentTime - startTime
                tbtReturn = getScore(elapsedTime, lockUntil: tbtReturn.lockout, totalScore: &StaticVariables.totalScores, isPrac: StaticVariables.isPractice)     //  Returns Time interval (lockout until) and score
                score += tbtReturn.score
            }else{
                if (self.stimArray[self.trialNumber][1] == "R"){  //
                    score += 1
                }
            }
        }
        return isPassable
    }
    
    func threadStimEnd() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
            let progress = self.checkScore()
            if (progress){
                DispatchQueue.main.sync {
                    self.makeButtonsInvisible()
                }
                self.stimEnd()
            }   //  Dont end the Trial if this is a TBT Time response
        }
    }
    
    //  Called on any correct answer
    func updatetotalScores(_ isPM: Bool, currPM: Int, isP: Bool){
        if (StaticVariables.currentTask == Task.ldt){
            StaticVariables.totalScores.ebLDTP += 1
            if (isPM){
                StaticVariables.totalScores.ebPMP[0] += 1
                StaticVariables.totalScores.ebPMP[currPM] = 1
            }
        }else if (StaticVariables.currentTask == Task.ebt){
            StaticVariables.totalScores.ebLDT += 1
            if (isPM){
                StaticVariables.totalScores.ebPM[0] += 1
                StaticVariables.totalScores.ebPM[currPM] = 1
            }
        }else if (StaticVariables.currentTask == Task.tbt){
            if (isP){
                StaticVariables.totalScores.tbLDTPCorrect += 1
            }else{
                StaticVariables.totalScores.tbLDTCorrect += 1
            }
        }
        
    }
    
    //  This function must be run on a thread
    func stimEnd() {
        let trialEndTime = Date.timeIntervalSinceReferenceDate
        var reactionTime = 0.0
        var corr = 0
        let elapsedTime = trialEndTime - startTime
        
        DispatchQueue.main.sync {
            self.targetWord.text = "+";
        }
        
        incrementTrialCounters()
        
        if (self.userResponse != "na"){                     //Check if the user responded
            reactionTime = trialEndTime - trialsStartTime   // Get reaction time
            if (self.stimArray[self.trialNumber][1] == "R"){
                currentPM += 1
            }
            
            if (self.stimArray[self.trialNumber][1] == self.userResponse){  //
                if (self.userResponse == "R"){      // Is PM
                    updatetotalScores(true, currPM: currentPM, isP: StaticVariables.isPractice)
                }else{
                    updatetotalScores(false, currPM: currentPM, isP: StaticVariables.isPractice)
                }
                corr = 1
            }
            
        }
        
        // Check if response is correct or not
        
        let response = Response(trialNum: self.trialNumber, trialType: String(describing: StaticVariables.currentTask), stim: self.stimArray[self.trialNumber][0], response: self.userResponse, rt: reactionTime, corr: corr, score: self.score, time: String(elapsedTime))
        
        self.userResponse = "na"        //  Reset response for trial timeout
        
        StaticVariables.responseArray.append(response)
        
        self.trialNumber += 1              //incriment trial counter
    
        if (self.trialNumber < self.numberOfTrials && self.isTimeToEnd != true) {        //  Not end of trials
            if (StaticVariables.currentTask != Task.tbt){
                Thread.sleep(forTimeInterval: TimeInterval(1.0))
            }else{
                Thread.sleep(forTimeInterval: TimeInterval(1.25))
            }
            DispatchQueue.main.sync {
                if (self.trialNumber < self.numberOfTrials){        //  Sanity check for the array index since this runs on a thread
                    self.trialTimerOpen = true
                    self.makeButtonsVisible()
                    self.targetWord.text = self.stimArray[self.trialNumber][0].uppercased()
                    self.enableButtons()
                    self.setTrialTimer()
                    self.trialsStartTime = Date.timeIntervalSinceReferenceDate   // Set new trial start time
                }
            }
        }else{      //  This is the end of Trials
            //  Cancel Timers if they are running
            print(StaticVariables.totalScores)
            if (StaticVariables.currentTask == Task.tbt){
                if (self.TBTTimer != nil){
                    self.TBTTimer?.invalidate()
                }
                if (StaticVariables.isPractice){
                    StaticVariables.totalScores.tbLDTPPercCorr = (Float(StaticVariables.totalScores.tbLDTPCorrect) / Float(StaticVariables.totalScores.tbLDTPAnswered)) * 100     //  Calc Percentages
                }else{
                    StaticVariables.totalScores.tbLDTPercCorr = (Float(StaticVariables.totalScores.tbLDTCorrect) / Float(StaticVariables.totalScores.tbLDTAnswered)) * 100      //  Calc Percentages
                }
            }
            print("Made it the saving csv bit in ViewController stimEnd")
            StaticVariables.csvString = structArrayToCSV(StaticVariables.responseArray)
            
            print("Made it to the end in ViewController stimEnd")
            DispatchQueue.main.sync {
                if (StaticVariables.currentTask == Task.tbt && StaticVariables.isPractice == false){
                    //At the end of the Trials
                    totalScoringToCsv(StaticVariables.totalScores)
                    self.performSegue(withIdentifier: "goodbyeSegue", sender: nil)
                }else{
                    self.dismiss(animated: true, completion: nil);
                }
            }
        }
        
    }
    
    func structArrayToCSV(_ responses: [Response]) -> String{
        var returnCSVString : String = "Trial No,Trial Type,Stimulus,Response,Response Time,Correct,Score,Elapsed Time\n"
        
        for response in responses {
            returnCSVString += String(response.trialNum) + "," + response.trialType + "," + response.stim + "," + response.response + "," + String(response.rt) + "," + String(response.corr) + "," + String(response.score) + "," + response.time + "\n"
        }
        
        return returnCSVString
    }
    
    func getCurrentTime() -> [Int]{
        let currentTime = Date.timeIntervalSinceReferenceDate
        //Find the difference between current time and start time.
        var elapsedTime = currentTime - startTime
        //calculate the minutes in elapsed time.
        let minutes = Int(elapsedTime / 60.0)
        elapsedTime = elapsedTime - Double(minutes * 60)
        //calculate the seconds in elapsed time.
        let seconds = Int(elapsedTime)
        return [minutes, seconds]
    }

    @objc func updateTime() {
        
        //print("whats the time mister wolf hahah.... ok ill get back to work")
        
        timerCount += 1    // Update timer count to stop at 8
        
        let timeArray = getCurrentTime()
        
        let minutes = timeArray[0]
        
        let seconds = timeArray[1]
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
    
        masterClock.text = "\(strMinutes):\(strSeconds)"
        //print("\(strMinutes):\(strSeconds)")
        
        if timerCount > 3 {
            timerCount = 0
            masterClock.text = ""
            masterTimer.invalidate()
            timerOpen = true
        }
        
    }
    
    var mThreeCounter = 0
    //  Check the amount of times the headder has been presed in the M Categories
    func getMScores(){
        
        let currentTime : [Int] = getCurrentTime()
        
        mThreeCounter += 1
        if (StaticVariables.isPractice){
            StaticVariables.totalScores.m3PCheck += 1
        }else{
            StaticVariables.totalScores.m3Check += 1
        }
        
        if (currentTime[0] < 1){
            if (currentTime[1] >= 45){
                mCheckCount[0][0] += 1         //Incriment M1 Count
                mCheckCount[0][1] += 1         //Incriment M2 Count
                if (StaticVariables.isPractice){
                    StaticVariables.totalScores.m1PCheck[0] += 1
                    StaticVariables.totalScores.m1PCheck[1] += 1
                    StaticVariables.totalScores.m2PCheck[0] += 1
                    StaticVariables.totalScores.m2PCheck[1] += 1
                }else{
                    StaticVariables.totalScores.m1Check[0] += 1
                    StaticVariables.totalScores.m1Check[1] += 1
                    StaticVariables.totalScores.m2Check[0] += 1
                    StaticVariables.totalScores.m2Check[1] += 1
                }
            }else if(currentTime[1] >= 30){
                mCheckCount[0][1] += 1         //Incriment M2 Count
                if (StaticVariables.isPractice){
                    StaticVariables.totalScores.m2PCheck[0] += 1
                    StaticVariables.totalScores.m2PCheck[1] += 1
                }else{
                    StaticVariables.totalScores.m2Check[0] += 1
                    StaticVariables.totalScores.m2Check[1] += 1
                }
            }
            mCheckCount[0][2] = mThreeCounter
        }else if(currentTime[0] < 2){
            if (currentTime[1] >= 45){
                mCheckCount[1][0] += 1         //Incriment M1 Count
                mCheckCount[1][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m1Check[0] += 1
                StaticVariables.totalScores.m1Check[2] += 1
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[2] += 1
            }else if(currentTime[1] >= 30){
                mCheckCount[1][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[2] += 1
            }
            mCheckCount[1][2] = mThreeCounter
        }else if(currentTime[0] < 3){
            if (currentTime[1] >= 45){
                mCheckCount[2][0] += 1         //Incriment M1 Count
                mCheckCount[2][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m1Check[0] += 1
                StaticVariables.totalScores.m1Check[3] += 1
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[3] += 1
            }else if(currentTime[1] >= 30){
                mCheckCount[2][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[3] += 1
            }
            mCheckCount[2][2] = mThreeCounter
        }else if(currentTime[0] < 4){
            if (currentTime[1] >= 45){
                mCheckCount[3][0] += 1         //Incriment M1 Count
                mCheckCount[3][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m1Check[0] += 1
                StaticVariables.totalScores.m1Check[4] += 1
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[4] += 1
            }else if(currentTime[1] >= 30){
                mCheckCount[3][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[4] += 1
            }
            mCheckCount[3][2] = mThreeCounter
        }else if(currentTime[0] < 5){
            if (currentTime[1] >= 45){
                mCheckCount[4][0] += 1         //Incriment M1 Count
                mCheckCount[4][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m1Check[0] += 1
                StaticVariables.totalScores.m1Check[5] += 1
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[5] += 1
            }else if(currentTime[1] >= 30){
                mCheckCount[4][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[5] += 1
            }
            mCheckCount[4][2] = mThreeCounter
        }else if(currentTime[0] < 6){
            if (currentTime[1] >= 45){
                mCheckCount[5][0] += 1         //Incriment M1 Count
                mCheckCount[5][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m1Check[0] += 1
                StaticVariables.totalScores.m1Check[6] += 1
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[6] += 1
            }else if(currentTime[1] >= 30){
                mCheckCount[5][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[6] += 1
            }
            mCheckCount[5][2] = mThreeCounter
        }else if(currentTime[0] < 7){
            if (currentTime[1] >= 45){
                mCheckCount[6][0] += 1         //Incriment M1 Count
                mCheckCount[6][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m1Check[0] += 1
                StaticVariables.totalScores.m1Check[7] += 1
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[7] += 1
            }else if(currentTime[1] >= 30){
                mCheckCount[6][1] += 1         //Incriment M2 Count
                StaticVariables.totalScores.m2Check[0] += 1
                StaticVariables.totalScores.m2Check[7] += 1
            }
            mCheckCount[6][2] = mThreeCounter
        }
    }
    
    func importCSV() {
        var fileLocation : String
        var fNameAppend = ""

        switch StaticVariables.currentTask {    //  Get File name append
        case .ldt:
            fNameAppend = "LDT"
        case .ebt:
            fNameAppend = "EBT"
        case .tbt:
            fNameAppend = "TBT"
        default:
            print("Error in import CSV switch Statement")
            break
        }
        
        if (StaticVariables.isPractice){
            print("fName is \(fNameAppend)Practice")
            fileLocation = Bundle.main.path(forResource: fNameAppend + "Practice", ofType: "csv")!
        }else{
            print("fName is \(fNameAppend)Main")
            fileLocation = Bundle.main.path(forResource: fNameAppend + "Main", ofType: "csv")!
        }
        
        let error: NSErrorPointer = nil
        print("FIlename is:  \(fileLocation)")
        
        if let csv = CSV(contentsOfFile: fileLocation, error: error) {
            // Rows
            stimArray = csv.aRows
        }
        if (error != nil){
            print("Error in View Controller importCSV :( \(String(describing: error))")
        }
        print("Made it to the end of importCSV")
    }
    
    func addButtonImages(){
        wordButtonOutlet.setBackgroundImage(buttonImage, for: UIControlState())
        nonWordButtonOutlet.setBackgroundImage(buttonImage, for: UIControlState())
        animalWordButtonOutlet.setBackgroundImage(buttonImage, for: UIControlState())
        wordButtonOutlet.setTitle("", for: UIControlState())
        nonWordButtonOutlet.setTitle("", for: UIControlState())
        animalWordButtonOutlet.setTitle("", for: UIControlState())
    }
    
    func enableButtons() {
        wordButtonOutlet.isEnabled = true
        nonWordButtonOutlet.isEnabled = true
        animalWordButtonOutlet.isEnabled = true
    }
    
    func disableButtons() {
        wordButtonOutlet.isEnabled = false
        nonWordButtonOutlet.isEnabled = false
        animalWordButtonOutlet.isEnabled = false
    }
    
    func makeButtonsInvisible(){
        wordButtonOutlet.isHidden = true
        nonWordButtonOutlet.isHidden = true
        animalWordButtonOutlet.isHidden = true
    }
    
    func makeButtonsVisible(){
        wordButtonOutlet.isHidden = false
        nonWordButtonOutlet.isHidden = false
        animalWordButtonOutlet.isHidden = false
    }

}

