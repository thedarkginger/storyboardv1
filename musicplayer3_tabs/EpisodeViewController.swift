//
//  EpisodeViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/17/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage


class EpisodeViewController: UIViewController {
    var timer: Timer?
    
    var nameVariableInSecondVc = ""
    var audioVariableInSecondVc = ""
    var showTitleVariable = ""
    var descriptionVariable = ""
    var imageVariable = ""
    
    
    var audiotest = "" {
        didSet{
        }
    }
    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        podImageView.sd_setImage(with: URL(string: imageVariable), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        self.title = showTitleVariable
        
        activity_indicator.isHidden = true
        
        let testName = nameVariableInSecondVc
        // this passes the audio url
        let testSite = audioVariableInSecondVc
        episodeTitle.text = testName
        
        // scroll episode name test
        
        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.episodeTitle.center = CGPoint(x: 0 - self.episodeTitle.bounds.size.width / 2, y: self.episodeTitle.center.y)
        }, completion:  { _ in })
        
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
            
            episodeTotalTime.text = String(format: "%02d:%02d:%02d", updated.0, updated.1, updated.2)
            
            
        } // end player
        
        
        
    } // end view did
    
    @IBOutlet var episodeTitle: UILabel!
    
    @IBOutlet var episodeDate: UILabel!
    
    @IBOutlet var podImageView: UIImageView!
    
    
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
        
        let episodeTime = (Float(audioPlayer.currentTime))
        let myIntValue = Int(episodeTime)
        
        
        let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
        
        episodeTimeTaken.text = String(format: "%02d:%02d:%02d", updated.0, updated.1, updated.2)
        
    }
    
    @IBAction func skipFortyFiveFwd(_ sender: Any) {
        
        let currentTime = audioPlayer.currentTime + 30.0
        
        
        audioPlayer.currentTime = TimeInterval(currentTime)
        
    }
    
    @IBAction func skipFortyFiveBack(_ sender: Any) {
        
        let currentTime = audioPlayer.currentTime - 30.0
        
        audioPlayer.currentTime = TimeInterval(currentTime)
        
        
    }
    
} //end


