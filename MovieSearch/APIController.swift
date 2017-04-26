//
//  APIController.swift
//  MovieSearch
//
//  Created by Kevin Lee on 10/19/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

import UIKit

protocol APIControllerDelegate {
    func finishSearch(result: Dictionary<String, AnyObject>)
}

class APIController {
    var delegate : APIControllerDelegate?
    init(delegate: APIControllerDelegate?){
        self.delegate = delegate
    }
    
//    func searchOMDb(search: String){
//        let noSpaceString = search.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
//        let urlPath = NSURL(string: "http://www.omdbapi.com/?s=\(noSpaceString!)")
//        print(urlPath!)
//        let myrequest: NSURLRequest = NSURLRequest(URL: urlPath!)
//        let mysession = NSURLSession.sharedSession()
//        let task = mysession.dataTaskWithRequest(myrequest) { data, response, error in
//            do {
//                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,AnyObject>
//                print(jsonResult)
//                if let isSetDelegate = self.delegate {
//                    dispatch_async(dispatch_get_main_queue()){
//                        isSetDelegate.finishSearch(jsonResult)
//                    }
//                }
//            
//                
//            } catch {
//                print(error)
//            }
//            
//        }
//        task.resume()
//    }
    func searchOMDb(search: String){
        //let noSpaceString = search.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let noSpaceString = search.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlPath = NSURL(string: "http://www.omdbapi.com/?s=\(noSpaceString!)")
        let urlPath2 = NSURL(string: "http://www.omdbapi.com/?s=\(noSpaceString!)&page=2")
        var numberOfResults = 0.0
        let myrequest: NSURLRequest = NSURLRequest(URL: urlPath!)
        let mysession = NSURLSession.sharedSession()
        let task = mysession.dataTaskWithRequest(myrequest) { data, response, error in
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,AnyObject>
                if let isSetDelegate = self.delegate {
                    dispatch_async(dispatch_get_main_queue()){
                        
                        if jsonResult["totalResults"] != nil{
                            
                        numberOfResults = (jsonResult["totalResults"] as! NSString).doubleValue
                        }
                    isSetDelegate.finishSearch(jsonResult)
                    }
                }
                
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
        if numberOfResults > 10{
        let myrequest2: NSURLRequest = NSURLRequest(URL: urlPath2!)
        let mysession2 = NSURLSession.sharedSession()
        let task2 = mysession2.dataTaskWithRequest(myrequest2) { data, response, error in
            do {
                let jsonResult2 = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,AnyObject>
                if let isSetDelegate = self.delegate {
                    dispatch_async(dispatch_get_main_queue()){
                        isSetDelegate.finishSearch(jsonResult2)
                    }
                }
                
                
            } catch {
                print(error)
            }
            
        }
        task2.resume()
        }
    }

}
