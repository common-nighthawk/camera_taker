//
//  ViewControllerGet.swift
//  camerataker
//
//  Created by Apprentice on 6/15/14.
//  Copyright (c) 2014 Skippers. All rights reserved.
//

import UIKit
import CoreLocation

class ViewControllerGet: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var textHacker = ""
//    var myLong = 0.0
//    var myLat = 0.0
//    var answerLat = ""
//    var answerLong = ""
    
    @IBOutlet var changeText : UILabel
    @IBOutlet var changeLat : UILabel
    @IBOutlet var changeLong : UILabel
    @IBOutlet var changeURL : UILabel
    @IBOutlet var changeImage : UIImageView // = nil (before sid)

    // after the view loads, start getting location
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        weak var weakSelf : ViewControllerGet? = self;
        //var myLat = 41.889663
        //var myLong = -87.637340
        var myLat = locationManager.location.coordinate.latitude
        var myLong = locationManager.location.coordinate.longitude

        var testLocation = CLLocation(latitude: myLat, longitude: myLong)
        self.fetchImageWithCLLocation(testLocation, handler: {
            (response: NSURLResponse!, image: UIImage!, error: NSError!) in
            if (!error)
            {
                // Success! We got back an image...bind the image returned in the closure to the changeImage UIImageView
                weakSelf!.changeImage.image = image
                self.changeText.text = self.textHacker
            }
        })
    }
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:CLLocation[])
    {
        var mostRecentLocation = locations[0]
    }
    
    
    // standard
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
// FORMAT lat and long
//    var once = 1
//    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
//        if once == 1 {
//            myLat = locations[0].coordinate.latitude
//            myLong = locations[0].coordinate.longitude
//
//            var counterlat = 0
//            var counterlong = 0
//            
//            for x in "\(myLat)" {
//                if x == "." { counterlat = 1 }
//                if counterlat < 8 { answerLat += x }
//                counterlat += 1
//            }
//            for x in "\(myLong)" {
//                if x == "." { counterlong = 1 }
//                if counterlong < 8 { answerLong += x }
//                counterlong += 1
//            }
//        }
//        once += 1
//    }

    
//    
// SID SET THIS UP FOR OUR LOGIC TO CHECK ONCE EVERY CHANGE IN X FEET
//    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:CLLocation[])
//    {
//        // locations array will contain CLLocation objects in chronological order - Most recent first
//        // For our case, we shoud only need to get the first object in this array
//        
//        // Grab the latitude and long from this CLLocation object
//        // call method to fetch image from services (backend) using lat/long
//        // ex. - func fetchImageWithCLLocation(location: CLLocation, handler: {(image: UIImage, error: NSError)()}.....handler should be a closure
//        var mostRecentLocation = locations[0]
//        weak var weakSelf : ViewControllerGet? = self
//   // ON BUTTON CLICK....
//        // the variable 'handler' is a closure that gets executed once a response comes back from the backend
//        self.fetchImageWithCLLocation(mostRecentLocation, handler: {
//            (response: NSURLResponse!, image: UIImage!, error: NSError!) in
//            if (error)
//            {
//                // Success! We got back an image...bind the image returned in the closure to the changeImage UIImageView
//                weakSelf!.changeImage.image = image
//            }
//        })
//    }
    
    
    func fetchImageWithCLLocation(location: CLLocation?, handler: ((NSURLResponse!, UIImage!, NSError!) -> Void)!)
    {
        println("--- fetch Image with Location")
        //TODO: fetch memory text with CLLOcation.  change method need.  need to return both text and image.
        // Create NSURLRequest object with correct properties set (base url, endpoint, url parameters, any post data, headers, etc.)
        // Make asynchronous call using NSURLConnection using sendAsynchronousRequest (use NSOperationQueue.mainOperationQueue as the operation queue for method, pass handler as the last parameter of the method call)
        if (!location)
        {
            return;
        }
        
        var request = NSMutableURLRequest();
        request.URL = NSURL(string: self.parameterizedURLFromLocation(location!, baseURL: "http://whispering-earth-2684.herokuapp.com/memories/"))
        request.HTTPMethod = "GET"
    // Daniel -- may cause problems
        request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
        // TODO: Figure out what's in the header for the request
        
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{
                (response: NSURLResponse!, data: NSData!, error: NSError!) in
                var jsonResult: NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                if (!jsonResult)
                {
                    return;
                }
                // make same if statement for text
                // if there is an image URL, write the method to fetch it
                
                var urlDictionary : NSDictionary = jsonResult!["image"] as NSDictionary
                var urlToImage : AnyObject? = urlDictionary["url"] as AnyObject?
                var textDictionary : NSString = jsonResult!["text"] as NSString
                self.textHacker = textDictionary

                println(urlDictionary)
                println(urlToImage)
                println(textDictionary)
                
                weak var weakSelf : ViewControllerGet? = self
                if (urlToImage)
                {
                    var kMaybeThisIsAnImage : String = urlToImage! as String
                    println("kMaybeThisIsAnImage: \(kMaybeThisIsAnImage)")
                    
                    weakSelf!.fetchImageAtURL(kMaybeThisIsAnImage, handler: {
                        (response: NSURLResponse!, image: UIImage!, error: NSError!) in
                        if handler
                        {
                            handler(response, image, error)
                        }
                        })
                }
            })
    }

    func fetchImageAtURL(url: String, handler: ((NSURLResponse!, UIImage!, NSError!) -> Void)!)
    {
        var request = NSMutableURLRequest();
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{
                (response: NSURLResponse!, data: NSData!, error: NSError!) in
                var img : UIImage = UIImage(data: data!)
                if handler
                {
                    handler(response, img, error)
                }
            })
    }
    
    func parameterizedURLFromLocation(location: CLLocation, baseURL: String) -> String
    {
        println("\(baseURL)?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)")
        return  "\(baseURL)?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
    }

    
// Manually retrieve memory.  WE ARE REMOVING THIS BUTTON.  NEED TO STEAL LOGIC FOR IF NO MEMORY
//    @IBAction func getMemory(sender : UIButton) {
//        
//        var url = NSURL(string: "http://whispering-earth-2684.herokuapp.com/memories/?latitude=\(answerLat)&longitude=\(answerLong)")
//        println(url)
//        
//        var request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "GET"
//        request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
//        
//        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
//        connection.start()
//    }
//    
//    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
//        var getText = ""
//        var getUrl = ""
//        
//        if data.length == 4 {
//            getText = "Just keep walking"
//            getUrl = "http://justsomething.co/wp-content/uploads/2014/01/hilarious-alpaca-hairstyles-12.jpg"
//        }
//        else {
//            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
//            var myText = jsonResult["text"]
//            var myUrl = jsonResult["image"]
//            getText = "\(myText)"
//            getUrl = "\(myUrl)"
//        }
//            var urlString: NSString = getUrl as NSString
//            var imgURL: NSURL = NSURL(string: urlString)
//            var imgData: NSData = NSData(contentsOfURL: imgURL)
//        
//            changeLat.text = answerLat        //REMOVE.  JUST FOR TESTING
//            changeLong.text = answerLong      //REMOVE JUST FOR TESTING
//            changeText.text = "\(getText)"
//            changeURL.text = "\(getUrl)"
//            changeImage.image = UIImage(data: imgData)
//    }
    
    
}