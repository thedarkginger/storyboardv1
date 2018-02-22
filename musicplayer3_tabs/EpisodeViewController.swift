//
//  EpisodeViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/17/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit
import AVFoundation

class EpisodeViewController: UIViewController {
    var timer: Timer?
    
    var nameVariableInSecondVc = ""
    var audioVariableInSecondVc = ""
    var showTitleVariable = ""
    var descriptionVariable = ""

    
    var audiotest = "" {
        didSet{
        }
    }
    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = showTitleVariable
                
        activity_indicator.isHidden = true
        
        let testName = nameVariableInSecondVc
        // this passes the audio url
        let testSite = audioVariableInSecondVc
        episodeTitle.text = testName
        
        episodeDescription.text = descriptionVariable
        
        if let audioUrl = URL(string: testSite) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            do {
                
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                    print("Playback OK")
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("Session is Active")
                } catch {
                    print(error)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
        
            
            // sets the duration time for the episode 
            
             func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
             return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
             }
             
             let episodeTime = (Float(audioPlayer.duration))
             let myIntValue = Int(episodeTime)
             let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
             let updated3 = "\(updated.0):\(updated.1):\(updated.2)"
             let updated2 = String(describing: updated3)
            
            episodeTotalTime.text = updated2

        } // end player
        
    } // end view did
    
    @IBOutlet var episodeTitle: UILabel!
    
    @IBOutlet var episodeDescription: UILabel!
    
    @IBOutlet var episodeDate: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var episodeTimeTaken: UILabel!
    @IBOutlet var episodeTotalTime: UILabel!
    
    @IBAction func playPod(_ sender: Any) {
        
        // updates slider with progress
        Slider.value = 0.0
        Slider.maximumValue = Float((audioPlayer?.duration)!)
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        audioPlayer.play()
        
    }
    
    @IBAction func pausePod(_ sender: Any) {
        if  audioPlayer.isPlaying{
            audioPlayer.pause()
            timer?.invalidate()
        }else{
            audioPlayer.play()
        }
        
    }
    
    @IBOutlet var Slider: UISlider!
    
    @IBAction func changePodSlider(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(Slider.value)
        audioPlayer.prepareToPlay()
        Slider.maximumValue = Float(audioPlayer.duration)
        audioPlayer.play()
    }
    @IBAction func click_close(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func updateSlider(){
        
        Slider.value = Float(audioPlayer.currentTime)
        
        //        audioPlayer.play()
        
        
        func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        
        let example = (Float(audioPlayer.currentTime))
        let myIntValue = Int(example)
        let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
        let updated3 = "\(updated.0):\(updated.1):\(updated.2)"
        let updated2 = String(describing: updated3)
        self.episodeTimeTaken.text = updated2
    }
    
    
    
    
} //end


