//
//  ThirdViewController.swift
//  MovieSearch
//
//  Created by Kevin Lee on 10/19/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var image2View: UIImageView!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    var imdbID = ""
    
    func searchDetails(search: String){
        //let noSpaceString = search.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let noSpaceString = search.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(noSpaceString!)")
        print(urlPath!)
        let myrequest: NSURLRequest = NSURLRequest(URL: urlPath!)
        let mysession = NSURLSession.sharedSession()
        let task = mysession.dataTaskWithRequest(myrequest) { data, response, error in
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,String>
                print(jsonResult)
                    dispatch_async(dispatch_get_main_queue()){
                        if(jsonResult["Title"] != nil){
                            self.title2Label.text = "Title: " + jsonResult["Title"]!
                        }
                        if(jsonResult["Year"] != nil){
                            self.releaseLabel.text = "Release: " + jsonResult["Year"]!
                        }
                        if(jsonResult["Rated"] != nil){
                            self.ratingLabel.text = "Rating: " + jsonResult["Rated"]!
                        }
                        if(jsonResult["Plot"] != nil){
                            self.imdbLabel.text = "Plot : " + jsonResult["Plot"]!
                        }
                        if(jsonResult["imdbID"] != nil){
                            self.imdbID = jsonResult["imdbID"]!
                        }
                        if(jsonResult["Poster"] != nil){
                            let posterURL = NSURL(string: jsonResult["Poster"]!)
                            let posterImage = NSData(contentsOfURL: posterURL!)
                            self.image2View.image = UIImage(data: posterImage!)
                        }
                    }
                
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    var mTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.image2View.image = mPoster
//        self.title2Label.text = "Title: " + mTitle
//        self.releaseLabel.text = "Release Date: " + mRelease
//        self.ratingLabel.text = "Rating: " + mRating
//        self.imdbLabel.text = "imdbID: " + mPlot
        removeButton.hidden = true
        let favorites = NSUserDefaults.standardUserDefaults()
        if favorites.arrayForKey("masterArray") != nil{
            let newArray = favorites.arrayForKey("masterArray")!
            var isThere = false
            for item in newArray{
                if item as! String == mTitle{
                    isThere = true
                }
            }
            if isThere{
                removeButton.hidden = false
            }
        }
        
        self.title2Label.sizeToFit()
        self.imdbLabel.sizeToFit()
        self.searchDetails(mTitle)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func favoritePressed(sender: AnyObject) {
        let favorites = NSUserDefaults.standardUserDefaults()
        if favorites.arrayForKey("masterArray") != nil{
            var newArray = favorites.arrayForKey("masterArray")!
            var isThere = false
            for item in newArray{
                if item as! String == mTitle{
                    isThere = true
                }
            }
            if !isThere{
            newArray.append(mTitle)
            favorites.setObject(newArray, forKey: "masterArray")
            }
        }
        else{
            let newArray = [String]()
            favorites.setObject(newArray, forKey: "masterArray")
        }
    }
    @IBAction func imdbPressed(sender: AnyObject) {
        if let url = NSURL(string: "http://www.imdb.com/title/\(imdbID)"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func removePressed(sender: AnyObject) {
         let favorites = NSUserDefaults.standardUserDefaults()
        if favorites.arrayForKey("masterArray") != nil{
        var newArray = favorites.arrayForKey("masterArray")
            var isThere = false
            for item in newArray!{
                if item as! String == mTitle{
                    isThere = true
                }
            }
            if isThere{
            let index = newArray!.indexOf {
                $0 as! String == mTitle
            }
            newArray!.removeAtIndex(index!)
            favorites.setObject(newArray, forKey: "masterArray")
            }
        }
    }
}
