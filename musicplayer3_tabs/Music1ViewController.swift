//
//  Music1ViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 12/11/17.
//  Copyright © 2017 storyboard. All rights reserved.
//

import UIKit
//4 -
import AVKit
import AVFoundation

class Music1ViewController: UIViewController {
    
    var player = AVPlayer()
    
    //15 -
    var hasBeenPaused = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func play(_ sender: Any) {
        
        let playerItem = AVPlayerItem(url: URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")!)
        player = AVPlayer(playerItem: playerItem)
        player.play()
    }
    
    @IBAction func pause(_ sender: Any) {
    
        player.pause()
        
    }
    
    @IBAction func restart(_ sender: Any) {

    }

    @IBOutlet var Slider: UISlider!
    
   
}

