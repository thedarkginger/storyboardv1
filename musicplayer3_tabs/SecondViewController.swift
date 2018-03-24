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

class SecondViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeTable.delegate = self
        
        subscribeTable.dataSource = self
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        return myarray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        cell.textLabel?.text = myarray[indexPath.row]
        
        return cell
            }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var subscribeTable: UITableView!
    
}
