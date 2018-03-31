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
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeTable.delegate = self
        
        subscribeTable.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        subscribeTable.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return getArray().count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        
        let myarray = getArray()
        
        cell.textLabel?.text = myarray[indexPath.row]
        
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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    
    @objc func tapaccessoryButton(sender:UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        let indexpath = IndexPath(row: tag!, section: 0)
        
        self.tableView(subscribeTable, accessoryButtonTappedForRowWith: indexpath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // test to see if i can store row name in the defaults array
        
        var myarray = getArray()
        
        myarray.remove(at: indexPath.row)
        
        setArray(ary: myarray)
        
        subscribeTable.reloadData()
        
        
        print(myarray)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getArray() -> [String] {
        
        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        return myarray
    }
    func setArray(ary: [String]){
        
        defaults.set(ary, forKey: "SavedStringArray")
    }
    
    @IBOutlet var subscribeTable: UITableView!
    
    
}
