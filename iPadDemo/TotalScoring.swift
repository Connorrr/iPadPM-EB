//
//  TotalScoring.swift
//  LDTPM
//
//  Created by Connor Reid on 16/05/2016.
//  Copyright © 2016 Connor Reid. All rights reserved.
//

struct TotalScoring {
    
    var ebLDTP : Int = 0                    //  Prac Total Score (0 - 16)                   accu (*)
    var ebPMP : [Int] = [0,0,0,0,0]         //  Total Score, EBPM1, ..., EBMP4              accu (*)
    var ebLDT : Int = 0                     //  LDT Total Score                             accu (*)
    var ebPM : [Int] = [0,0,0,0,0,0,0]      //  Total, EBPM1, EMPM2, ...                    accu (*)
    
    var tbLDTPAnswered : Int = 0            //  Number Answered in the 1.5 mins             accu (*)
    var tbLDTPCorrect : Int = 0             //  Number Correct                              accu (*)
    var tbLDTPPercCorr : Float = 0.0        //  Percentage Correct                          end  (*)
    var tbPMP : [Int] = [0,0]               //  Total Score, TBPM1                          accu (*)
    
    var tbLDTAnswered : Int = 0             //  Number Answered in the 1.5 mins             accu (*)
    var tbLDTCorrect : Int = 0              //  Number Correct                              accu (*)
    var tbLDTPercCorr : Float = 0.0         //  Percentage Correct                          end  (*)
    var tbPM : [Int] = [0,0,0,0,0,0,0]      //  Total Score, TBPM2, TBPM3, ...              accu (*)
    
    var m1PCheck : [Int] = [0,0]            //  Total Score, TBPM1 (between 45-60s)         accu (*)
    var m2PCheck : [Int] = [0,0]            //  Total Score, TBPM2 (between 30-60s)         accu (*)
    var m3PCheck : Int = 0                  //  Clock Checks in the 1.5 mins                accu (*)
    
    var m1Check : [Int] = [0,0,0,0,0,0,0]   //  Total Score, TBPM1 (15s Before the min)     accu (*)
    var m2Check : [Int] = [0,0,0,0,0,0,0]   //  Total Score, TBPM2 (30s before the min)     accu (*)
    var m3Check : Int = 0                   //  Clock Checks in the 6.5 mins                accu (*)
    
}

