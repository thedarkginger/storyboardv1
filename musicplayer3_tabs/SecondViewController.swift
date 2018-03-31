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
    
    
    var TableData: [String] =  [String] ()
    
    var avPlayer:AVPlayer?
    var avPlayerItem:AVPlayerItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeTable.delegate = self
        
        subscribeTable.dataSource = self
        
        let defaults = UserDefaults.standard
        var myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        TableData = myarray
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return TableData.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        cell.textLabel?.text = myarray[indexPath.row]
        
        if myarray.contains(TableData[indexPath.row]){
            print("something")
            var imageView : UIImageView
            imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.image = UIImage(named:"checkmark.png")
            
            imageView.tag = indexPath.row
            imageView.isUserInteractionEnabled = true
            let tapgest = UITapGestureRecognizer()
            tapgest.addTarget(self, action: #selector(tapaccessoryButton(sender:)))
            
            imageView.addGestureRecognizer(tapgest)
            cell.accessoryView?.isUserInteractionEnabled = true
            
            cell.accessoryView = imageView
            
            
            
        }else{
            
            var imageView : UIImageView
            imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.image = UIImage(named:"star.png")
            imageView.tag = indexPath.row
            imageView.isUserInteractionEnabled = true
            let tapgest = UITapGestureRecognizer()
            tapgest.addTarget(self, action: #selector(tapaccessoryButton(sender:)))
            
            imageView.addGestureRecognizer(tapgest)
            cell.accessoryView = imageView
            cell.accessoryView?.isUserInteractionEnabled = true
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    
    @objc func tapaccessoryButton(sender:UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        let indexpath = IndexPath(row: tag!, section: 0)
        
        if indexpath != nil {
            
            self.tableView(subscribeTable, accessoryButtonTappedForRowWith: indexpath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // test to see if i can store row name in the defaults array
        let defaults = UserDefaults.standard
        var myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        if let datastring = TableData[indexPath.row] as? String {
            if myarray.contains(datastring) {
                myarray.remove(at: myarray.index(of: datastring)!)
                
                // this is where I want it to delete the row and then I can remove the image lines below
                // tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            defaults.set(myarray, forKey: "SavedStringArray")
        }
        

        // this should set the accessory to the second image on click
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named:"star.png")
        
        let cell = tableView.cellForRow(at: indexPath)
        //cell?.accessoryType = .checkmark
        cell?.accessoryView = imageView
 
        print(myarray)
        
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
