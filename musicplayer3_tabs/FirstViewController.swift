//
//  FirstViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 12/7/17.
//  Copyright © 2017 storyboard. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var arrData = [episode]()
    var arrShow = [String]()
    
    @IBOutlet weak var nowPlayingImageView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingImageView.imageView?.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.imageView?.animationDuration = 1.0
        
        // sets nav bar to dark theme
        navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        
        episodeTable.delegate = self
        
        episodeTable.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        get_data_from_url("https://api.myjson.com/bins/w23ln")//http://www.fearthewave.com/fearthewave.json
        
        arrShow = getArray()
        
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
    
    @IBOutlet var episodeTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = "\(arrData[indexPath.row].show) - \(arrData[indexPath.row].name)"
        return cell
    }
    
    func getArray() -> [String] {
        
        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        return myarray
    }
    
    func setArray(ary: [String]){
        
        defaults.set(ary, forKey: "SavedStringArray")
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
    
    // download episode list
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            self.extract_json(data!)
        })
        
        task.resume()
        
    }
    
    func extract_json(_ data: Data)
    {
        
        let json: Any?
        do{
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch{
            return
        }
        
        guard let data_list = json as? NSArray else {
            return
        }
        
        if let shows_list = json as? NSArray
        {
            arrData.removeAll()
            
            for i in 0 ..< data_list.count
            {
                var episodeobj = episode()
                if let shows_obj = shows_list[i] as? NSDictionary
                {
                    
                    let episode_name = shows_obj["episode"] as? String
                    let episode_show = shows_obj["show"] as? String
                    let epside_audio = shows_obj["url"] as? String
                    let episode_date = shows_obj["date"] as? String
                    
                    episodeobj.show = episode_show!
                    episodeobj.name = episode_name!
                    episodeobj.audio = epside_audio
                    episodeobj.date = episode_date!
                    
                    let dateformate = DateFormatter()
                    dateformate.dateFormat = "MM-dd-yyyy"
                    let epdate = dateformate.date(from: episode_date!)
                    if epdate == nil {
                        
                        episodeobj.episode_date = Date()
                    }
                    else {
                        
                        episodeobj.episode_date = epdate
                    }
                    //
                }
                
                if arrShow.contains(episodeobj.show) {
                    
                    arrData.append(episodeobj)
                }
                
                self.arrData = self.arrData.sorted(by: {$0.episode_date > $1.episode_date })
                
                let when = DispatchTime.now() + 0.2
                
                DispatchQueue.main.asyncAfter(deadline: when) {
                    
                    self.episodeTable.reloadData()
                }
                
            }
            
            // DispatchQueue.main.async(execute: {self.getDownloadAudio()})
        }
        
    }
    
}

