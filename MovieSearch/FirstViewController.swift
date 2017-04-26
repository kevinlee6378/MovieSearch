//
//  FirstViewController.swift
//  MovieSearch
//
//  Created by Kevin Lee on 10/19/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, APIControllerDelegate, UISearchBarDelegate, UICollectionViewDelegate,
UICollectionViewDataSource{

    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.White)

    @IBOutlet weak var movieSearch: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notFoundLabel: UILabel!
    lazy var APIControl : APIController = APIController(delegate: self)
    
    var moviesArray: [Movie] = [Movie(title: "N/A", release: "N/A", rating: "N/A", plot: "N/A", poster: "N/A", favorite: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.APIControl.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        //let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
       // tap.cancelsTouchesInView = false
       // self.view.addGestureRecognizer(tap)
    }
    func finishSearch(search: Dictionary<String, AnyObject>) {
        if search["Response"] as! String != "False"{
        let array = search["Search"] as! [Dictionary<String,String>]
        for dictionary in array {
            var thisMovie = Movie(title: "N/A", release: "N/A", rating: "N/A", plot: "N/A", poster: "N/A", favorite: false)
            if let title = dictionary["Title"] {
                thisMovie.title = title
            }
            if let release = dictionary["Year"]{
                thisMovie.release = release
            }
            if let rating = dictionary["Rated"]{
                thisMovie.rating = rating
            }
            if let plot = dictionary["Plot"]{
                thisMovie.plot = plot
            }
            if let poster = dictionary["Poster"]{
                thisMovie.poster = poster
            }
            moviesArray.append(thisMovie)
        }
        }
        else {
            notFoundLabel.adjustsFontSizeToFitWidth = true
            notFoundLabel.text = "No Movies Found"
        }
        collectionView.reloadData()
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count
    }
    let imageCache = NSCache()
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        if indexPath.row < moviesArray.count{
            if self.moviesArray[indexPath.row].title != "N/A"{
                cell.titleLabel.adjustsFontSizeToFitWidth = true
                cell.titleLabel.text = self.moviesArray[indexPath.row].title
            }
            if self.moviesArray[indexPath.row].poster != "N/A"{
                let posterString = self.moviesArray[indexPath.row].poster
                
                if (imageCache.objectForKey(posterString) != nil){
                    cell.imageView.clipsToBounds = true
                    cell.imageView.image = imageCache.objectForKey(posterString) as? UIImage
                }
                else{
                    let posterURL = NSURL(string: self.moviesArray[indexPath.row].poster)
                    let posterImageData = NSData(contentsOfURL: posterURL!)
                    let posterImage = UIImage(data: posterImageData!)
                    imageCache.setObject(posterImage!, forKey: posterString)
                    cell.imageView.clipsToBounds = true
                    cell.imageView.image = posterImage!
                }
                //cell.imageView.clipsToBounds = true
                //cell.imageView.image = UIImage(data: posterImage!)
            }
        }
        cell.contentView.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("a", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "a" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! ThirdViewController
            //if self.moviesArray[indexPath.row].poster != "N/A"{
            //let posterURL = NSURL(string: self.moviesArray[indexPath.row].poster)
            //let posterImage = NSData(contentsOfURL: posterURL!)
            //vc.mPoster = UIImage(data: posterImage!)!
            //}
            vc.mTitle = self.moviesArray[indexPath.row].title
            //vc.mRelease = self.moviesArray[indexPath.row].release
            //vc.mRating = self.moviesArray[indexPath.row].rating
            //vc.mPlot = self.moviesArray[indexPath.row].plot
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        //let firstMovie: Movie = Movie(title: search["Title"]!, release: search["Released"]!, rating: search["Rated"]!, plot: search["Plot"]!, poster: search["Poster"]! as! String, favorite: false)
//        self.titleLabel.text = firstMovie.title
//        self.releaseLabel.text = firstMovie.release
//        self.displayImage(firstMovie.poster)
//        self.titleLabel.text = result["Title"]
//        self.releaseLabel.text = result["Released"]
//        self.ratingLabel.text = result["Rated"]
//        self.plotLabel.text = result["Plot"]
//        if let isSetPoster = result["Poster"] {
//            self.displayImage(isSetPoster)
//        }
   // func displayImage(url: String){
     //   let posterURL = NSURL(string: url)
       // let posterImage = NSData(contentsOfURL: posterURL!)
//        self.posterImage.clipsToBounds = true
//        self.posterImage.image = UIImage(data: posterImage!)
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        indicator.color = UIColor.whiteColor()
        indicator.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        notFoundLabel.text = ""
        moviesArray = []
        self.APIControl.searchOMDb(searchBar.text!)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
   // func dismissKeyboard(){
     //   view.endEditing(true)
   // }
}

