//
//  TableViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/15/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
var audiotest = ""

class episodeTableViewController: UITableViewController {
    
    var TableDataV : [episode] = [episode]()
    var showNameVariable = ""
    
    var activity_indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(showNameVariable)"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
    
        playerToolbar.isHidden = true
        playerToolbar.items = [pauseButton]

        
        if (audioPlayer != nil) {
            if  audioPlayer.isPlaying {
                playerToolbar.isHidden = false
            }else{
                playerToolbar.isHidden = true

            }
            
        }
 
        activity_indicator.frame = CGRect(x: 50, y: 50, width: 20, height: 20)
        activity_indicator.isHidden = true
        activity_indicator.center = self.view.center
        activity_indicator.color = UIColor.black
        
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.window!.addSubview(activity_indicator)
        
        let d = DispatchTime.now() + 0.5
        
        DispatchQueue.main.asyncAfter(deadline: d) {
            
            self.view.addSubview(self.activity_indicator)
            self.view.bringSubview(toFront: self.activity_indicator)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView!.reloadData()
        
        print("viewwillappear used")
        
        // change to https and change info plist before prod
        get_data_from_url("http://www.fearthewave.com/fearthewave.json")
        
        // reload data to get checkmark if downloaded
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableDataV.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let epi = TableDataV[indexPath.row]
        
        cell.textLabel?.text = epi.date + " | " + epi.name
        
        // extract json audio file
        
        var url = ""
        
        if (epi.paywall == "no") {
            cell.backgroundColor = UIColor(red:0.89, green:0.95, blue:0.99, alpha:1.0)
        } else {
            cell.backgroundColor = UIColor(red:1.00, green:0.93, blue:0.70, alpha:1.0)
        }
        
        if epi.audio != nil {
            
            url = epi.audio!
            
            if let audioUrl = URL(string: url) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                
                print(destinationUrl)
                
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    
                    cell.accessoryType = .checkmark
                    
                }
                else{
                    
                    // this is the code I am testing
                    let downloadicon = UIImage(named: "download.png")
                    cell.accessoryType = .detailDisclosureButton
                    cell.accessoryView = UIImageView(image: downloadicon)
                }
                
                
            } // end audio if
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // doSomethingWithItem(indexPath.row)
        
        let epi = TableDataV[indexPath.row]
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
                    
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.accessoryType = .checkmark
                    
                    
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
                                vc.nameVariableInSecondVc = epi.name
                                vc.audioVariableInSecondVc = epi.audio!
                                
                                let cell = tableView.cellForRow(at: indexPath)
                                cell?.accessoryType = .checkmark
                                
                            }
                            
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }).resume()
                }
                
                
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    
    
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
            TableDataV.removeAll()
            
            for i in 0 ..< data_list.count
            {
                if let shows_obj = shows_list[i] as? NSDictionary
                {
                    print("test" + showNameVariable)
                    if (shows_obj["show"] as? String == "\(showNameVariable)") {
                        
                        let episode_name = shows_obj["episode"] as? String
                        let episode_date = shows_obj["date"] as? String
                        let epside_audio = shows_obj["url"] as? String
                        let episode_description = shows_obj["description"] as? String
                        let episode_image = shows_obj["image"] as? String
                        let episode_paywall = shows_obj["paywall"] as? String
                        
                        TableDataV.append(episode(name: episode_name!, date: episode_date!, audio: epside_audio, description: episode_description!, image: episode_image!, paywall: episode_paywall!))
                        
                        // sets the image for the table
                        showCoverImage.sd_setImage(with: URL(string: episode_image!), placeholderImage: UIImage(named: "placeholder.png"))
                        
                        
                    } else {
                        print("no matches")
                    }
                }
                
            }
        }
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    
    @IBAction func click_close(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let epi = TableDataV[indexPath.row]
        
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
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.nameVariableInSecondVc = epi.name
                    vc.audioVariableInSecondVc = epi.audio!
                    vc.showTitleVariable = self.showNameVariable
                    vc.descriptionVariable = epi.description
                    vc.imageVariable = epi.image!
                    
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
                                vc.nameVariableInSecondVc = epi.name
                                vc.audioVariableInSecondVc = epi.audio!
                                vc.showTitleVariable = self.showNameVariable
                                vc.imageVariable = epi.image!
                                
                                
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
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! EpisodeViewController
            
            let epi = TableDataV[indexPath.row]
            
            controller.nameVariableInSecondVc = epi.name
            
            var url = ""
            
            if epi.audio != nil {
                
                url = epi.audio!
                
                controller.audioVariableInSecondVc = epi.audio!
                
            }
            
        }
        
    }
    
    @IBOutlet var playButton: UIBarButtonItem!
    @IBOutlet var pauseButton: UIBarButtonItem!
    @IBAction func pauseAudioPlayer(_ sender: Any) {
        
        if  audioPlayer.isPlaying{
            audioPlayer.pause()
            timer?.invalidate()
            playerToolbar.items = [playButton]

        }else{
            audioPlayer.play()
        }
    }
    @IBAction func playAudioPlayer(_ sender: Any) {
        
        audioPlayer.play()
        playerToolbar.items = [pauseButton]
    }
    @IBOutlet var showCoverImage: UIImageView!
    
    @IBOutlet weak var playerToolbar: UIToolbar!
    // end
}

struct episode {
    
    var name = ""
    var date = ""
    var audio : String?
    var show = ""
    var description = ""
    var image : String?
    var paywall = ""
    
    init(name:String,date:String,audio:String?, description:String, image:String?, paywall:String) {
        
        self.name = name
        self.date = date
        self.audio = audio
        self.description = description
        self.image = image
        self.paywall = paywall
    }
    init() {
        
        self.name = ""
        self.date = ""
        self.audio = ""
        self.show = ""
        self.description = ""
        self.image = ""
        self.paywall = ""
        
    }
}
