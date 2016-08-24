//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Javier Mendoza on 22/8/16.
//  Copyright © 2016 Javier Mendoza. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton : UIButton!
    @IBOutlet weak var chipmunkButton : UIButton!
    @IBOutlet weak var darthVaderButton : UIButton!
    @IBOutlet weak var echoButton : UIButton!
    @IBOutlet weak var rabbitButton : UIButton!
    @IBOutlet weak var reverbButton : UIButton!
    @IBOutlet weak var stopButton : UIButton!
    
    var recordedAudioURL : NSURL!
    var audioFile : AVAudioFile!
    var audioEngine : AVAudioEngine!
    var audioPlayerNode : AVAudioPlayerNode!
    var stopTimer : NSTimer!
    
    
    enum ButtonType : Int {
        case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fix for low sound
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        setupAudio()
    }
    
    override func viewWillAppear(animated: Bool) {
        configureUI(.NotPlaying)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundForButton(sender: UIButton){
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate : 0.5)
        case .Fast:
            playSound(rate : 1.5)
        case .Chipmunk:
            playSound(pitch : 1000)
        case .Vader:
            playSound(pitch : -1000)
        case .Echo:
            playSound(echo : true)
        case .Reverb:
            playSound(reverb : true)
        }
        
        configureUI(.Playing)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject){
        stopAudio()
    }


}