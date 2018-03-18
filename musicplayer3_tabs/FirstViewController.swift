//
//  FirstViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 12/7/17.
//  Copyright © 2017 storyboard. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var nowPlayingImageView: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nowPlayingImageView.imageView?.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.imageView?.animationDuration = 1.0
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if (audioPlayer != nil) {
            if  audioPlayer.isPlaying {
               
                nowPlayingImageView.isHidden = false
                startNowPlayingAnimation(true)
                
            }else{
               
                nowPlayingImageView.isHidden = true
                startNowPlayingAnimation(false)
                
            }
            
        }
        else {
            
            nowPlayingImageView.isHidden = true
            startNowPlayingAnimation(false)
        }
         
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startNowPlayingAnimation(_ animate: Bool) {
        
        animate ? nowPlayingImageView.imageView?.startAnimating() : nowPlayingImageView.imageView?.stopAnimating()
    }
    
    @IBAction func Click_Wave(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

