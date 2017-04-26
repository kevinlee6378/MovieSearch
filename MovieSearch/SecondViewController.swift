//
//  SecondViewController.swift
//  MovieSearch
//
//  Created by Kevin Lee on 10/19/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoritesTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fav = NSUserDefaults.standardUserDefaults()
        if fav.arrayForKey("masterArray") != nil{
            if fav.arrayForKey("masterArray")?.count != 0{
        return (fav.arrayForKey("masterArray")?.count)!
            }
            else{
                return 1
            }
        }
        else {
            return 0
        }
    }
    override func viewWillAppear(animated: Bool) {
        favoritesTable.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let fav = NSUserDefaults.standardUserDefaults()
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath)
        //let titleArray = fav.arrayForKey("Title")
        //cell.textLabel?.text = titleArray![indexPath.item] as? String
        if fav.arrayForKey("masterArray")?.count != 0 {
        cell.textLabel?.text = fav.arrayForKey("masterArray")![indexPath.item] as? String
            cell.userInteractionEnabled = true
        }
        else{
            cell.textLabel?.text = "No Favorite Movies Yet"
            cell.userInteractionEnabled = false
        }
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("favDetails", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let fav = NSUserDefaults.standardUserDefaults()
        if segue.identifier == "favDetails" {
            let indexPaths = self.favoritesTable!.indexPathsForSelectedRows
            let indexPath = indexPaths![0] as NSIndexPath
            let vc = segue.destinationViewController as? ThirdViewController
                let title = fav.arrayForKey("masterArray")![indexPath.row] as! String
                print(title)
                vc!.mTitle = title
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

