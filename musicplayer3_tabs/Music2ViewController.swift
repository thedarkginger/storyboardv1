//
//  Music2ViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/6/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit
import AVFoundation

var timer: Timer?

class Music2ViewController: UIViewController {
    var count = 0
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let audioUrl = URL(string: "https://rss.art19.com/episodes/4a49a897-61a7-4a2c-81d5-4a7568339d38.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                
                func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                }
                
                let example = (Float(audioPlayer.duration))
                let myIntValue = Int(example)
                let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
                let updated3 = "\(updated.0):\(updated.1):\(updated.2)"
                let updated2 = String(describing: updated3)
                self.episodeDuration.text = updated2
                
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @IBOutlet var episodeDuration: UILabel!
    
    @IBAction func downloadFile(_ sender: Any) {
        
        if let audioUrl = URL(string: "https://rss.art19.com/episodes/4a49a897-61a7-4a2c-81d5-4a7568339d38.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                //show file downloaded
                    self.checkDownload.text = "Downloaded"
                checkDownload.backgroundColor = UIColor.green
    
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                }).resume()
            }
        }
    }
    
    @IBOutlet var checkDownload: UILabel!
    
    @IBAction func playDownload(_ sender: Any) {
        
        // updates slider with progress
        Slider.value = 0.0
        Slider.maximumValue = Float((audioPlayer?.duration)!)
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        

            audioPlayer.play()
  
        
    }
    
    @IBAction func pause(_ sender: Any) {
        
        if  audioPlayer.isPlaying{
            audioPlayer.pause()
            timer?.invalidate()
        }else{
            audioPlayer.play()
        }
    }
    
    @IBOutlet var Slider: UISlider!
    
    @IBOutlet var goneTime: UILabel!
    @IBAction func changeAudioTime(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(Slider.value)
        audioPlayer.prepareToPlay()
        Slider.maximumValue = Float(audioPlayer.duration)
        audioPlayer.play()
        
    }
    
    @objc func updateSlider(){
        
        Slider.value = Float(audioPlayer.currentTime)
        
        func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        
        let example = (Float(audioPlayer.currentTime))
        let myIntValue = Int(example)
        let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
        let updated3 = "\(updated.0):\(updated.1):\(updated.2)"
        let updated2 = String(describing: updated3)
        self.goneTime.text = updated2
    }
    
    func stopPlayer() {
        audioPlayer?.stop()
        timer?.invalidate()
        print("Player and timer stopped")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
