//
//  PodcastsTableViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/20/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit

class PodcastsTableViewController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()
    
    @IBOutlet weak var nowPlayingImageView: UIButton!
   
    var show_image = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change to https and change info plist before prod
        get_data_from_url("https://api.myjson.com/bins/15xvm9")
        

        
        nowPlayingImageView.imageView?.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.imageView?.animationDuration = 1.0

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showcell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        
        // this should set the accessory to the first image 
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named:"pausebutton.png")
        
        cell.accessoryView = imageView
        
        // cell.accessoryType = .detailDisclosureButton
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // test to see if i can store row name in the defaults array
        let defaults = UserDefaults.standard
        var myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        if let datastring = TableData[indexPath.row] as? String {
            if !myarray.contains(datastring) {
                myarray.append(datastring)
                defaults.set(myarray, forKey: "SavedStringArray")
                defaults.synchronize()
            }
        }
        
        // this should set the accessory to the second image on click
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named:"download.png")
    
        let cell = tableView.cellForRow(at: indexPath)
        //cell?.accessoryType = .checkmark
        cell?.accessoryView = imageView
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! episodeTableViewController
            controller.showNameVariable = TableData[indexPath.row]
            
        
        }
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
            for i in 0 ..< data_list.count
            {
                if let shows_obj = shows_list[i] as? NSDictionary
                {
                    let show_name = shows_obj["show"] as? String
                    // remove genre from the text 
                    // let show_genre = shows_obj["genre"] as? String
                    let show_image = shows_obj["thumbnail"] as? String
                    TableData.append(show_name!)
                    
                    let testPictureURL = URL(string: "https://pbs.twimg.com/profile_images/901973198727651328/v19Dj1As_400x400.jpg")!
                    
                    let session = URLSession(configuration: .default)
                    
                    // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
                    let downloadPicTask = session.dataTask(with: testPictureURL) { (data, response, error) in
                        // The download has finished.
                        if let e = error {
                            print("Error downloading cat picture: \(e)")
                        } else {
                            // No errors found.
                            // It would be weird if we didn't have a response, so check for that too.
                            if let res = response as? HTTPURLResponse {
                                print("Downloaded cat picture with response code \(res.statusCode)")
                                if let imageData = data {
                                    // Finally convert that Data into an image and do what you wish with it.
                                    let image = UIImage(data: imageData)
                                    // Do something with your image.
                                    
                                    DispatchQueue.main.async(execute: {self.do_table_refresh()})
                                    
                                } else {
                                    print("Couldn't get image: Image is nil")
                                }
                            } else {
                                print("Couldn't get response code for some reason")
                            }
                        }
                    }
                    
                    downloadPicTask.resume()
                }
            }
        }
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    } 

    @IBAction func Click_wave(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
