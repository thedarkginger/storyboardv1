//
//  SecondViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 12/7/17.
//  Copyright © 2017 storyboard. All rights reserved.
//

import UIKit

import AVFoundation

class SecondViewController: UIViewController {
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let urlstring = "http://www.noiseaddicts.com/samples_1w72b820/2514.mp3"
        let urlstring = "https://s3.amazonaws.com/kargopolov/kukushka.mp3"
        let url = NSURL(string: urlstring)
        print("playing \(String(describing: url))")
        
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.volume = 1.0
        avPlayer?.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

