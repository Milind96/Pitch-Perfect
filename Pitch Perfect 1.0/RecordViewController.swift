//
//  ViewController.swift
//  Pitch Perfect 1.0
//
//  Created by milind shelat on 07/05/19.
//  Copyright © 2019 milind shelat. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder : AVAudioRecorder!
    
    let segueToSecondViewController = "stopRecording"
    
    @IBOutlet weak var recordingButton: UIButton!

    @IBOutlet weak var stoprecording: UIButton!
    
    @IBOutlet weak var recordingStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stoprecording.isEnabled = false
        stoprecording.isHidden = true
    }
    
    
    @IBAction func startRecordingAudio(_ sender: Any) {
        //Function to record a file
        configureUI(playState: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        print(pathArray)
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecordingAudio(_ sender: Any) {
        //Function to stop the recording of a file
        configureUI(playState: false)
        let audioSession = AVAudioSession.sharedInstance()
        try!audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: segueToSecondViewController, sender: audioRecorder.url)
        }
        else{
            let alert = UIAlertController(title: "Alert!", message: "Recording failed", preferredStyle: .alert)
            let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueToSecondViewController {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
    func configureUI(playState: Bool) {
        if playState {
            recordingStateLabel.text = "Recording..."
            stoprecording.isEnabled = true
            stoprecording.isHidden = false
            recordingButton.isEnabled = false
        }
        else {
            recordingButton.isEnabled = true
            stoprecording.isEnabled = false
            stoprecording.isHidden = true
            recordingStateLabel.text = "Tap to Record"
            audioRecorder.stop()
        }
    }
}
