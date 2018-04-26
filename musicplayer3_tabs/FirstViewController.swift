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
    var showNameVariable = ""
    var cellHeight : CGFloat = 121
    
    // var activity_indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nowPlayingImageView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodeTable.tableFooterView = UIView()
        
        nowPlayingImageView.imageView?.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.imageView?.animationDuration = 1.0
        
        // sets nav bar to dark theme
        navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        activity_indicator.isHidden = true
        
        episodeTable.delegate = self
        
        episodeTable.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        get_data_from_url("http://www.fearthewave.com/fearthewave.json")
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let livedata = arrData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FirstViewCell
        
        cell.img_song.sd_setImage(with: URL(string: livedata.image!), completed: nil)
        cell.lbl_title.numberOfLines = 0
        cell.lbl_title.text = "\(livedata.name)"
        cell.lbl_title.sizeToFit()
        
        cell.lbl_date.text = livedata.date
        
        let lblS = cell.lbl_date.frame.origin.y + cell.lbl_date.frame.size.height + 10
        
        let imgS = cell.img_song.frame.origin.y + cell.img_song.frame.size.height + 10
        
        if !(lblS < imgS) {
            
            cellHeight = cell.lbl_date.frame.origin.y + cell.lbl_date.frame.size.height + 10
        }
        else {
            
            cellHeight = 121
        }
        
        
        
        // extract json audio file
        
        var url = ""
        
        if (livedata.paywall == "no") {
            cell.contentView.backgroundColor = UIColor(red:0.89, green:0.95, blue:0.99, alpha:1.0)
        } else {
            cell.contentView.backgroundColor = UIColor(red:1.00, green:0.93, blue:0.70, alpha:1.0)
        }
        
        if livedata.audio != nil {
            
            url = livedata.audio!
            
            if let audioUrl = URL(string: url) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                
                print(destinationUrl)
                
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    
                    cell.img_status.image = #imageLiteral(resourceName: "verification-mark")
                }
                else{
                    
                    // this is the code I am testing
                    cell.img_status.image = UIImage(named: "download.png")
                    cell.img_status.isUserInteractionEnabled = true
                    cell.img_status.tag = indexPath.row
                    let tapgest = UITapGestureRecognizer()
                    tapgest.addTarget(self, action: #selector(tapaccessoryButton(sender:)))
                    cell.img_status.addGestureRecognizer(tapgest)
                    
                }
                
                
            } // end audio if
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let epi = arrData[indexPath.row]
        
        var url = ""
        
        if epi.audio != nil {
            
            url = epi.audio!
            
            if let audioUrl = URL(string: url) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    
                    print("The file already exists at path")
                    
                    audioPlayer = nil
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    nameVariableInSecondVc = epi.name
                    audioVariableInSecondVc = epi.audio!
                    showTitleVariable = self.showNameVariable
                    descriptionVariable = epi.description
                    imageVariable = epi.image!
                    showDateVariable = epi.date
                    
                    // if the file doesn't exist
                } else {
                    
                    activity_indicator.isHidden = false
                    activity_indicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    // you can use NSURLSession.sharedSession to download the data asynchronously
                    URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                        guard let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: destinationUrl)
                            print("File moved to documents folder")
                            
                            
                            let when = DispatchTime.now()
                            
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                
                                self.activity_indicator.isHidden = true
                                self.activity_indicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                audioPlayer = nil
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                                nameVariableInSecondVc = epi.name
                                audioVariableInSecondVc = epi.audio!
                                showTitleVariable = self.showNameVariable
                                imageVariable = epi.image!
                                
                                
                            }
                            
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }).resume()
                }
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = episodeTable.indexPathForSelectedRow {
            let controller = segue.destination as! EpisodeViewController
            
            let epi = arrData[indexPath.row]
            
            nameVariableInSecondVc = epi.name
            
            var url = ""
            
            if epi.audio != nil {
                
                url = epi.audio!
                
                audioVariableInSecondVc = epi.audio!
                
            }
            
        }
        
    }
    
    @objc func tapaccessoryButton(sender:UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        let indexpath = IndexPath(row: tag!, section: 0)
        
        self.tableView(episodeTable, accessoryButtonTappedForRowWith: indexpath)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // doSomethingWithItem(indexPath.row)
        
        let epi = arrData[indexPath.row]
        var url = ""
        if epi.audio != nil {
            
            url = epi.audio!
            
            if let audioUrl = URL(string: url) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.relativePath) {
                    print("The file already exists at path")
                    
                    let cell = tableView.cellForRow(at: indexPath) as! FirstViewCell
                    cell.img_status.image = #imageLiteral(resourceName: "verification-mark")
                    
                    
                    // if the file doesn't exist
                } else {
                    
                    activity_indicator.isHidden = false
                    activity_indicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    // you can use NSURLSession.sharedSession to download the data asynchronously
                    URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                        guard let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: destinationUrl)
                            print("File moved to documents folder")
                            
                            
                            let when = DispatchTime.now()
                            
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                
                                self.activity_indicator.isHidden = true
                                self.activity_indicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                                nameVariableInSecondVc = epi.name
                                audioVariableInSecondVc = epi.audio!
                                imageVariable = epi.image!
                                
                                let cell = tableView.cellForRow(at: indexPath) as! FirstViewCell
                                cell.img_status.image = #imageLiteral(resourceName: "verification-mark")
                                
                            }
                            
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }).resume()
                }
                
                
            }
        }
        
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
                    let paywall = shows_obj["paywall"] as? String
                    
                    episodeobj.show = episode_show!
                    episodeobj.name = episode_name!
                    episodeobj.audio = epside_audio
                    episodeobj.date = episode_date!
                    episodeobj.image = shows_obj["image"] as? String
                    episodeobj.paywall = paywall!
                    
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
    
    struct episode {
        
        var name = ""
        var date = ""
        var audio : String?
        var show = ""
        var description = ""
        var image : String?
        var paywall = ""
        var episode_date : Date!
        
        init(name:String,date:String,audio:String?, description:String, image:String?, paywall:String,episode_date:Date) {
            
            self.name = name
            self.date = date
            self.audio = audio
            self.description = description
            self.image = image
            self.paywall = paywall
            self.episode_date = episode_date
        }
        init() {
            
            self.name = ""
            self.date = ""
            self.audio = ""
            self.show = ""
            self.description = ""
            self.image = ""
            self.paywall = ""
            self.episode_date = Date()
        }
    }
    
}


