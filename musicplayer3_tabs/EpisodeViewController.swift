//
//  EpisodeViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/17/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    var variableInSecondVc = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixed = variableInSecondVc.components(separatedBy: " | ")
        let fixedSite = fixed[1]
        let fixedDate = fixed[0]
        episodeTitle.text = fixedSite
        episodeDate.text = fixedDate
        
        print("https://fearthewave.com/\(fixedSite)")
        
        // Do any additional setup after loading the view.
    }
    
        @IBOutlet var episodeTitle: UILabel!

    @IBOutlet var episodeDate: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
