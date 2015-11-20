//: Playground - noun: a place where people can play

import UIKit

import CSV

let fileLocation = NSBundle.mainBundle().pathForResource("LDTPractice", ofType: "csv")!

let error: NSErrorPointer = nil
if let csv = CSV(contentsOfFile: fileLocation, error: error) {
    // Rows
    stimArray = csv.rows
}