//
//  InstructionsViewController.swift
//  iPadDemo
//
//  Created by Connor Reid on 18/11/2015.
//  Copyright © 2015 Connor Reid. All rights reserved.
//

import UIKit
import AVFoundation

class InstructionsViewController: UIViewController {
    
    // MARK:  Properties
    
    @IBOutlet weak var mainTextField: UITextView!
    
    @IBOutlet weak var buzzerLabel: UILabel!
    
    //  MARK:  Instance Variables
    
    var viewCount = 0                   //  Times the view has been accessed
    var pracFrameCount = 1              //  The current text slide
    var htmlFName = ""
    var buzzerTimer: Timer?           //  Timer to play the buzzer
    var audioPlayer = AVAudioPlayer()   //  Audioplayer for the buzzer
    var timerLength = 30.0              //  Seconds to wait until buzzer
    var fontSize: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.view.addGestureRecognizer(tapRecognizer)
        
        print("Hey dudes geta load of this instructions view")
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("I Segue'd in my pants")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("....  Just gotta find this....  um view was it?")
        
        buzzerLabel.isHidden = true
        
        htmlFName = getHtmlFName()
        
        if (htmlFName == "MainInstructions" || htmlFName == "Done"){
            setText(htmlFName)
        }else{
            setText(htmlFName+"1")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  Functions
    
    //  Returns the
    func getHtmlFName() -> String{
        var fName = ""
        switch StaticVariables.currentTask {
        case .ldt:
            if(StaticVariables.isPractice){
                fName = "LDTP"
            }else{
                fName = "MainInstructions"
            }
        case .ebt:
            fName = "EBT" + StaticVariables.version
        case .tbt:
            if(StaticVariables.isPractice){
                fName = "TBTP"
            }else{
                fName = "TBT" + StaticVariables.version
            }
        default:
            fName = "Done"
        }
        return fName
    }
    
    
    var isSlideUnlocked = true  //  A lock to make sure that the participant waits for the buzzer
    @objc func viewTapped(){
        // invalidate buzzer timer if it exists
        if (buzzerTimer != nil){
            buzzerTimer?.invalidate()
        }
        if (isSlideUnlocked){
            pracFrameCount += 1
        }
        buzzerLabel.text = "Press Screen to start timer"
        buzzerLabel.isHidden = true
        let moreSlides = setText(htmlFName + "\(pracFrameCount)")
        buzzerCheck(pracFrameCount)
        if (moreSlides == false){   //  Go until there are no more slides
            pracFrameCount = 1
            performSegue(withIdentifier: "trialsSegue", sender: nil)
        }
    }
    
    //  Checks and sets the buzzer.  Be sure to invalidate at the end of each slide
    @discardableResult func buzzerCheck(_ frame: Int) -> Bool{
        var isBuzzerSlide = false
        if (StaticVariables.version == "B"){    //  Only in B
            switch StaticVariables.currentTask {
            case .ebt:
                if (frame == 4){
                    isBuzzerSlide = true
                    if (isSlideUnlocked){
                        buzzerLabel.isHidden = false
                    }else{
                        buzzerLabel.isHidden = true
                        buzzerTimer = Timer.scheduledTimer(timeInterval: timerLength, target: self, selector: #selector(self.playBuzzer), userInfo: nil, repeats: false)
                    }
                    isSlideUnlocked = false
                }
            case .tbt:
                if (!StaticVariables.isPractice){
                    if (frame == 4){
                        isBuzzerSlide = false
                        if (isSlideUnlocked){
                            buzzerLabel.isHidden = false
                        }else{
                            buzzerLabel.isHidden = true
                            buzzerTimer = Timer.scheduledTimer(timeInterval: timerLength, target: self, selector: #selector(self.playBuzzer), userInfo: nil, repeats: false)
                        }
                        isSlideUnlocked = false
                    }
                }
            default:
                break
            }
        }
        return isBuzzerSlide
    }
    
    @objc func playBuzzer(){
        isSlideUnlocked = true
        buzzerLabel.text = "Press anywhere on the screen to continue"
        buzzerLabel.isHidden = false
        let buzzerSound = URL(fileURLWithPath: Bundle.main.path(forResource: "buzzer", ofType: "mp3")!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: buzzerSound)
        }catch{
            print("AudioPlayer failed to init with URL:  \(buzzerSound)")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    // Returns true if succeeded
    @discardableResult func setText(_ fName:  String) -> Bool{
        let url = Bundle.main.url(forResource: fName, withExtension: "html")
        //print("This is the fName:  \(String(describing: url))")
        if (url == nil){
            return false
        }
        let opts = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html]
        var d : NSDictionary? = nil
        let s = try! NSAttributedString(url: url!, options: opts, documentAttributes: &d)
        self.mainTextField.attributedText = s
        self.mainTextField.font = UIFont(name: "Helvetica", size: fontSize)
        return true
    }

}
