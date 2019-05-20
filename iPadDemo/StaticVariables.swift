//
//  StaticVariables.swift
//  iPadDemo
//
//  Created by Connor Reid on 24/11/2015.
//  Copyright © 2015 Connor Reid. All rights reserved.
//

import Foundation

public struct StaticVariables {
    static var isPractice : Bool = true         //  Counts the amout of times the main view is accessed
    static var csvString : String = ""          //  String used as the meat in log file sandwich
    static var csvTBTString : String = ""          //  String used as the meat in TBT log file sandwich
    static var csvButtonPressString : String = ""   //  String used for Button Press Logfile
    static var participant : String = ""        //  Participant ID
    static var trialsStartTime : TimeInterval!//  Used for the master timer clock
    static var currentTask = Task.ldt
    static var version = ""                     //  Version A or B
    static var responseArray : [Response] = []
    static var buttonPresses : [ButtonAndTime] = []
    static var totalScores : TotalScoring = TotalScoring()      //
}
