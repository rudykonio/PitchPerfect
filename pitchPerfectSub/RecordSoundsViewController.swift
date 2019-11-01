//
//  RecordSoundsViewController.swift
//  pitchPerfectSub
//
//  Created by Rodion Konioshko on 25/10/2019.
//  Copyright © 2019 Rodion Konioshko. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        uiConfigure(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"{
            let playSoundsVC=segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioUrl=recordedAudioURL
        }
    }
    
    @IBAction func stopRecording(_ sender:Any){
        uiConfigure(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func uiConfigure(_ recording:Bool){
        if recording{
            recordingLabel.text="Recording"
            stopRecordingButton.isEnabled=true
            recordButton.isEnabled=false
        }else{
            recordingLabel.text="Tap to Record"
            stopRecordingButton.isEnabled=false
            recordButton.isEnabled=true
        }
    }
}
