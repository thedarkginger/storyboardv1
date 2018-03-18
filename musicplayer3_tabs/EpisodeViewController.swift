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
import AudioToolbox

var nameVariableInSecondVc = ""
var audioVariableInSecondVc = ""
var showTitleVariable = ""
var descriptionVariable = ""
var imageVariable = ""

class EpisodeViewController: UIViewController {
    var timer: Timer?
    
    
    
    
    var audiotest = "" {
        didSet{
        }
    }
    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nowPlayingImageView: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingImageView.imageView?.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.imageView?.animationDuration = 1.0
        
        podImageView.sd_setImage(with: URL(string: imageVariable), placeholderImage: UIImage(named: "placeholder.png"))
        podImageView.layer.cornerRadius = 8.0
        podImageView.clipsToBounds = true
        
        self.title = showTitleVariable
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)

        
        activity_indicator.isHidden = true
        
        let testName = nameVariableInSecondVc
        // this passes the audio url
        let testSite = audioVariableInSecondVc
        episodeTitle.text = testName
        

        
        // pause play behavior
        
        self.pauseButtonMain.isHidden = true

        if audioPlayer == nil {
            
            if let audioUrl = URL(string: testSite) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                
                do {
                    
                    audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                    // sets the duration time for the episode
                    
                    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                    }
                    
                    let episodeTime = (Float(audioPlayer.duration))
                    let myIntValue = Int(episodeTime)
                    
                    
                    let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
                    
                    episodeTotalTime.text = String(format: "%02d:%02d:%02d", updated.0, updated.1, updated.2)
                    
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
       
            }
        }
        
        else {
            
            func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
            }
            
            let episodeTime = (Float(audioPlayer.duration))
            let myIntValue = Int(episodeTime)
            
            if audioPlayer.isPlaying {
                
                startNowPlayingAnimation(true)
            }
            
            let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
            
            episodeTotalTime.text = String(format: "%02d:%02d:%02d", updated.0, updated.1, updated.2)
            
            Slider.maximumValue = Float(audioPlayer.duration)
            playButtonMain.isHidden = true
            pauseButtonMain.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
            
        }
        
        
        
 // end player
        
        
        
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
    
    @IBOutlet weak var playButtonMain: UIButton!
    @IBOutlet weak var pauseButtonMain: UIButton!
    
    @IBAction func playButtonMain(_ sender: Any) {
        
        self.playButtonMain.isHidden = true
        self.pauseButtonMain.isHidden = false
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        } else {
            // Fallback on earlier versions
        }
        
        // updates slider with progress
        Slider.value = 0.0
        Slider.maximumValue = Float((audioPlayer?.duration)!)
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        startNowPlayingAnimation(true)
        audioPlayer.play()
        
    }
    
    @IBAction func pauseButtonMain(_ sender: Any) {
        
        startNowPlayingAnimation(false)
        self.playButtonMain.isHidden = false
        self.pauseButtonMain.isHidden = true
        
        if  audioPlayer.isPlaying{
            audioPlayer.pause()
            timer?.invalidate()
        }else{
            audioPlayer.play()
        }
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        
        animate ? nowPlayingImageView.imageView?.startAnimating() : nowPlayingImageView.imageView?.stopAnimating()
    }
    
} //end


