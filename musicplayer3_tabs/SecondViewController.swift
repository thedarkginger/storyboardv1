//
//  SecondViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 12/7/17.
//  Copyright © 2017 storyboard. All rights reserved.
//

import UIKit
import AVFoundation
var audioPlayer:AVAudioPlayer!

class SecondViewController: UIViewController {
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

