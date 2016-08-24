//
//  RecordSoundsViewContrller.swift
//  PitchPerfect
//
//  Created by Javier Mendoza on 22/8/16.
//  Copyright © 2016 Javier Mendoza. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewContrller: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    // raw values correspond to sender tags
    enum RecordingState { case Recording, NotRecording }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.enabled=false
    }

    @IBAction func recordAudio(sender: AnyObject) {
        
        configureUI(.Recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        
        
        // Original from leason
        //try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // fix for low sound
        try! session.setCategory(AVAudioSessionCategoryRecord)
        
        
        // Optional fix for low sound
        //try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        
        configureUI(.NotRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

        
    }
    
    func configureUI(recordState: RecordingState) {
        switch(recordState) {
        case .Recording:
            recordingLabel.text="Recording in progress"
            stopRecordingButton.enabled=true
            recordingButton.enabled=false
        case .NotRecording:
            stopRecordingButton.enabled=false
            recordingLabel.text="Tap to Record"
            recordingButton.enabled=true
        }
    }

    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }else{
            print("Saving recording failed!")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}

