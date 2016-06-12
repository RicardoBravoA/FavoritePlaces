//
//  TableViewController.swift
//  FavoritePlaces
//
//  Created by Ricardo Bravo Acuña on 12/06/16.
//  Copyright © 2016 Ricardo Bravo Acuña. All rights reserved.
//

import UIKit

var places = [Dictionary<String, String>]()
var index = -1
var desc:String = "description"
var lat:String = "lat"
var lon:String = "lon"
var userData:String = "userData"
let preference  = NSUserDefaults.standardUserDefaults()

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if preference.valueForKey(userData) != nil{
            places = preference.valueForKey(userData) as! [Dictionary<String, String>]
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = places[indexPath.row][desc]

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            places.removeAtIndex(indexPath.row)
            preference.setValue(places, forKey: userData)
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        index = indexPath.row
        
        return indexPath
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addPoint"{
            index = -1
        }
        
     }

}
