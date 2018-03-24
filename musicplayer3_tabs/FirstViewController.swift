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
        
        // sets nav bar to dark theme
        navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
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

