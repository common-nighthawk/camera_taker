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
    var myLong = 0.0
    var myLat = 0.0
    var answerLat = ""
    var answerLong = ""

    // after the view loads, start getting location
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //var timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
//    func update() {
//        println("YEAH")
//    }
    
    // standard
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var changeText : UILabel
    @IBOutlet var changeLat : UILabel
    @IBOutlet var changeLong : UILabel
    @IBOutlet var changeURL : UILabel
    @IBOutlet var changeImage : UIImageView = nil
    
    var once = 1
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
        if once == 1 {
            myLat = locations[0].coordinate.latitude
            myLong = locations[0].coordinate.longitude //SEE IF WE CAN FIX THIS THROUGH THE API

            var counterlat = 0
            var counterlong = 0
            
            for x in "\(myLat)" {
                if x == "." { counterlat = 1 }
                if counterlat < 8 { answerLat += x }
                counterlat += 1
            }
            for x in "\(myLong)" {
                if x == "." { counterlong = 1 }
                if counterlong < 8 { answerLong += x }
                counterlong += 1
            }
        }
        once += 1
    }

    
    
    @IBAction func getMemory(sender : UIButton) {
        var url = NSURL(string: "http://quiet-ravine-8717.herokuapp.com/memories/?latitude=\(answerLat)&longitude=\(answerLong)")
        println(url)
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        var getText = ""
        var getUrl = ""
        
        if data.length == 4 {
            getText = "Just keep walking"
            getUrl = "http://justsomething.co/wp-content/uploads/2014/01/hilarious-alpaca-hairstyles-12.jpg"
        }
        else {
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            var myText = jsonResult["text"]
            var myUrl = jsonResult["image"]
            getText = "\(myText)"
            getUrl = "\(myUrl)"
        }
            var urlString: NSString = getUrl as NSString
            var imgURL: NSURL = NSURL(string: urlString)
            var imgData: NSData = NSData(contentsOfURL: imgURL)
        
            changeLat.text = answerLat        //REMOVE.  JUST FOR TESTING
            changeLong.text = answerLong      //REMOVE JUST FOR TESTING
            changeText.text = "\(getText)"
            changeURL.text = "\(getUrl)"
            changeImage.image = UIImage(data: imgData)
    }
}