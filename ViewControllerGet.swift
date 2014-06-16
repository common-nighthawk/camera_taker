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
    var answerlat = ""
    var answerlong = ""

    // after the view loads, start getting location
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // standard
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var changeText : UILabel
    @IBOutlet var changeImage : UIImageView
    
    var once = 1
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
        if once == 1 {
            myLat = locations[0].coordinate.latitude
            myLong = locations[0].coordinate.longitude * -1

            var counterlat = 0
            var counterlong = 0
            
            for x in "\(myLat)" {
                if x == "." { counterlat = 1 }
                if counterlat < 8 { answerlat += x }
                counterlat += 1
            }
            
            for x in "\(myLong)" {
                if x == "." { counterlong = 1 }
                if counterlong < 8 { answerlong += x }
                counterlong += 1
            }
        }
        once += 1
    }

    @IBAction func getMemory(sender : UIButton) {        
        println("GET requesting.")
        
        var long = answerlong
        var lat = answerlat
        println(long)
        println(lat)
        
        var url = NSURL(string: "http://young-beach-6740.herokuapp.com/memories?latitude=\(lat)&longitude=\(long)")
        println(url)
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
        
        println(request)
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        println(connection)
        
        connection.start()
        
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        println("pop")
        println(data.length)
        println(data.description)
        // var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        println("double pop")
//        println(jsonResult["text"])
//        var getText = jsonResult["text"]
//        
//        changeText.text = "\(getText)"
    }

}