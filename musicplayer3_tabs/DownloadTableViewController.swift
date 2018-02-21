//
//  DownloadTableViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 2/12/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit

class DownloadTableViewController: UITableViewController {
    
    var thedownloads = [String]()
    var theurls = [URL]()
    var arrData = [episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data_from_url("http://www.fearthewave.com/fearthewave.json")
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                var episodeobj = episode()
                if let shows_obj = shows_list[i] as? NSDictionary
                {
                    let episode_name = shows_obj["episode"] as? String
                    let episode_show = shows_obj["show"] as? String
                    let epside_audio = shows_obj["url"] as? String
                    
                    episodeobj.show = episode_show!
                    episodeobj.name = episode_name!
                    episodeobj.audio = epside_audio
                }
                
                arrData.append(episodeobj)
            }
            
            DispatchQueue.main.async(execute: {self.getDownloadAudio()})
        }
        
        
    }
    
    func getDownloadAudio() {
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            
            thedownloads.removeAll()
            
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            // print(directoryContents)
            theurls = directoryContents
            
            
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            //print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            //print("mp3 list:", mp3FileNames)
            
            for mp3file in mp3FileNames {
                
                for obj in arrData {
                    
                    if (obj.audio?.contains(mp3file))! {
                        
                        let name = "\(obj.show) - \(obj.name)"
                        thedownloads.append(name)
                    }
                }
            }
            self.tableView.reloadData()
            // thedownloads = mp3FileNames
            
        } catch {
            print(error.localizedDescription)
        }
        
        print(thedownloads)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return thedownloads.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showcell", for: indexPath)
        
        cell.textLabel?.text = thedownloads[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = thedownloads[indexPath.row]
        print(url)
        
        do {
            try FileManager.default.removeItem(at: theurls[indexPath.row])
            // self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            // self.tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            thedownloads.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try FileManager.default.removeItem(at: theurls[indexPath.row])
                
            } catch let error {
                print(error)
            }
            
            
            // end if
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     
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
