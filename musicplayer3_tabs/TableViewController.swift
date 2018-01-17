//
//  TableViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/15/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change to https and change info plist before prod
        get_data_from_url("https://api.myjson.com/bins/1hdenx")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
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
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_list = json as? NSArray else
        {
            return
        }
        
        if let shows_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let shows_obj = shows_list[i] as? NSDictionary
                {
                    let episode_name = shows_obj["episode"] as? String
                    let episode_date = shows_obj["date"] as? String
                    TableData.append(episode_date! + " | " + episode_name!)
                }
                
            }
            
        }
        
        /*
        if let countries_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let country_obj = countries_list[i] as? NSDictionary
                {
                    if let country_name = country_obj["country"] as? String
                    {
                        if let country_code = country_obj["code"] as? String
                        {
                            TableData.append(country_name + " [" + country_code + "]")
                        }
                    }
                }
            }
        }
 
 */
        
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    
    
}
