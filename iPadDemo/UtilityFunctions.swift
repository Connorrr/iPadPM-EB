//
//  UtilityFunctions.swift
//  LDTPM
//
//  Created by Connor Reid on 15/04/2016.
//  Copyright © 2016 Connor Reid. All rights reserved.
//

import Foundation

struct ButtonAndTime{
    var button: String
    var time: TimeInterval
}

struct LockAndScore{
    var lockout: TimeInterval
    var score: Int
}

func getScore(_ time: TimeInterval, lockUntil: TimeInterval, totalScore: UnsafeMutablePointer<TotalScoring>, isPrac: Bool) -> LockAndScore{
    
    if (time < lockUntil){
        print("Locked out until \(lockUntil) bro")
        
        return LockAndScore(lockout: lockUntil, score: 0)
    }
    
    var lockOut: TimeInterval
    var score = 0
    
    let thresholds: [TimeInterval] = [TimeInterval(60.0 + 15.0), TimeInterval(120.0+15.0), TimeInterval(180.0+15.0), TimeInterval(240.0+15.0), TimeInterval(300.0+15.0)]
    
    if (time <= thresholds[0]){
        if (time < TimeInterval(75.0) && time > TimeInterval(45.0)){
            score = 1
            if (time < TimeInterval(70.0) && time > TimeInterval(50.0)){
                score = 2
                if (time < TimeInterval(65.0) && time > TimeInterval(55.0)){
                    score = 3
                }
            }
        }
        if (isPrac){
            totalScore.pointee.tbPMP[0] += score
            totalScore.pointee.tbPMP[1] = score
        }else{
            totalScore.pointee.tbPM[0] += score
            totalScore.pointee.tbPM[1] = score
        }
        lockOut = thresholds[0]
    }else if(time <= thresholds[1]){
        if (time < TimeInterval(135.0) && time > TimeInterval(105.0)){
            score = 1
            if (time < TimeInterval(130.0) && time > TimeInterval(110.0)){
                score = 2
                if (time < TimeInterval(125.0) && time > TimeInterval(115.0)){
                    score = 3
                }
            }
        }
        totalScore.pointee.tbPM[0] += score
        totalScore.pointee.tbPM[2] = score
        lockOut = thresholds[1]
    }else if(time <= thresholds[2]){
        if (time < TimeInterval(195.0) && time > TimeInterval(165.0)){
            score = 1
            if (time < TimeInterval(190.0) && time > TimeInterval(170.0)){
                score = 2
                if (time < TimeInterval(185.0) && time > TimeInterval(175.0)){
                    score = 3
                }
            }
        }
        totalScore.pointee.tbPM[0] += score
        totalScore.pointee.tbPM[3] = score
        lockOut = thresholds[2]
    }else if(time <= thresholds[3]){
        if (time < TimeInterval(255.0) && time > TimeInterval(225.0)){
            score = 1
            if (time < TimeInterval(250.0) && time > TimeInterval(230.0)){
                score = 2
                if (time < TimeInterval(245.0) && time > TimeInterval(235.0)){
                    score = 3
                }
            }
        }
        totalScore.pointee.tbPM[0] += score
        totalScore.pointee.tbPM[4] = score
        lockOut = thresholds[3]
    }else if(time <= thresholds[4]){
        if (time < TimeInterval(315.0) && time > TimeInterval(285.0)){
            score = 1
            if (time < TimeInterval(310.0) && time > TimeInterval(290.0)){
                score = 2
                if (time < TimeInterval(305.0) && time > TimeInterval(295.0)){
                    score = 3
                }
            }
        }
        totalScore.pointee.tbPM[0] += score
        totalScore.pointee.tbPM[5] = score
        lockOut = thresholds[4]
    }else{
        if (time < TimeInterval(375.0) && time > TimeInterval(345.0)){
            score = 1
            if (time < TimeInterval(370.0) && time > TimeInterval(350.0)){
                score = 2
                if (time < TimeInterval(365.0) && time > TimeInterval(355.0)){
                    score = 3
                }
            }
        }
        totalScore.pointee.tbPM[0] += score
        totalScore.pointee.tbPM[6] = score
        lockOut = TimeInterval(450.0)
    }
    
    return LockAndScore(lockout: lockOut, score: score)
}

//  Converts to the final csvstring then saves as file
func totalScoringToCsv(_ scores: TotalScoring){
    var csvString = "Event Based\nType of Score,Total Score,EBPM1,EBPM2,EBPM3,EBPM4,EBPM5,EBPM6\n"
    
    // Get EB Prac Score
    csvString += "EB LDT Practice,\(scores.ebLDTP)\nEB PM Practice,\(scores.ebPMP[0]),\(scores.ebPMP[1])"
    csvString += ",\(scores.ebPMP[2]),\(scores.ebPMP[3]),\(scores.ebPMP[4])\n"
    csvString += "EB LDT,\(scores.ebLDT)\nEB PM,\(scores.ebPM[0]),\(scores.ebPM[1]),\(scores.ebPM[2]),\(scores.ebPM[3])"
    csvString += ",\(scores.ebPM[4]),\(scores.ebPM[5]),\(scores.ebPM[6])\nTime-Based\nType of Score,Total Score,TBPM1,TBPM2,TBPM3,TBPM4,TBPM5,TBPM6\n , ,60s,120s,180s,240s,300s,360s\n"
    csvString += "TB LDT Practice Answered,\(scores.tbLDTAnswered)\nTB LDT Practice Correct,\(scores.tbLDTPCorrect)\n"
    csvString += "TB LDT Practice Percentage Corr,\(scores.tbLDTPPercCorr)\nTB PM Practice,\(scores.tbPMP[0]),\(scores.tbPMP[1])\n"
    csvString += "\nTB LDT Answered,\(scores.tbLDTAnswered)\nTB LDT Correct,\(scores.tbLDTCorrect)\nTB LDT Percentage Corr,\(scores.tbLDTPercCorr)\n"
    csvString += "TBPM,\(scores.tbPM[0]),\(scores.tbPM[1]),\(scores.tbPM[2]),\(scores.tbPM[3]),\(scores.tbPM[4]),\(scores.tbPM[5]),\(scores.tbPM[6])\n"
    csvString += "Time-Based Practice Monitoring Scores\nM1 Practice,Total Score,TBPM1\n"
    csvString += "M1 Practice Check,\(scores.m1PCheck[0]),\(scores.m1PCheck[1])\n"
    csvString += "M2 Practice Check,\(scores.m2PCheck[0]),\(scores.m2PCheck[1])\nM3 Practice Check,\(scores.m3PCheck)\n"
    csvString += "Time-Based Monitoring Scores\nM1,Total Score,TBPM1,TBPM2,TBPM3,TBPM4,TBPM5,TBPM6\n"
    csvString += "M1 Check,\(scores.m1Check[0]),\(scores.m1Check[1]),\(scores.m1Check[2]),\(scores.m1Check[3]),\(scores.m1Check[4]),\(scores.m1Check[5]),\(scores.m1Check[6])\n"
    csvString += "M2 Check,\(scores.m2Check[0]),\(scores.m2Check[1]),\(scores.m2Check[2]),\(scores.m2Check[3]),\(scores.m2Check[4]),\(scores.m2Check[5]),\(scores.m2Check[6])\n"
    csvString += "M3 Check,\(scores.m3Check)"
    
    saveCSV(csvString, fName: "Compressed")
}

//  Save a string as a csv file
func saveCSV(_ log: String, fName: String) {
    let file = StaticVariables.participant + "_" + StaticVariables.version + "_\(fName)_log.csv" //this is the file. we will write to and read from it
    
    let text = log //just a text
    //print(log)
    
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
        let path = dir.appendingPathComponent(file);
        print("Path for csv is \(path)")
        
        //writing
        do {
            try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("Um OK...  I don't want you to over react but...  someshitgotfuckedupwhiletryingtosavethatfile....K..bye...")
        }
        
    }
}

func TBTArrayToCsvString(_ score: Int, mChecks: [[Int]]) -> String{
    var returnCSVString : String = "Time,Score,M1Check,M2Check,M3Checks\n"
    
    for x in 0..<mChecks.count{
        
        if (x == 0){
            returnCSVString += "60s,"
        }else if(x == 1){
            returnCSVString += "120s,"
        }else if(x == 2){
            returnCSVString += "180s,"
        }else if(x == 3){
            returnCSVString += "240s,"
        }else if(x == 4){
            returnCSVString += "300s,"
        }else if(x == 5){
            returnCSVString += "360s,"
        }else{
            returnCSVString += "420s,"
        }
        
        returnCSVString += "\(score),"
        for y in 0..<mChecks[x].count{
            returnCSVString += "\(mChecks[x][y]),"
        }
        returnCSVString += "\n"
    }
    
    return returnCSVString
}

func buttonArrayToCSV(_ buttons: [ButtonAndTime]) -> String{
    print("Entered buttonArrayToCSV")
    var csvString = "Button,Time Interval\n"
    
    for button in buttons {
        csvString += button.button + ",\(button.time)\n"
    }
    
    StaticVariables.csvButtonPressString = csvString
    return csvString
}

//  Used to increment total score trial counters
func incrementTrialCounters(){
    if (StaticVariables.currentTask == Task.tbt){
        if (StaticVariables.isPractice){
            StaticVariables.totalScores.tbLDTPAnswered += 1
        }else{
            StaticVariables.totalScores.tbLDTAnswered += 1
        }
    }
}


