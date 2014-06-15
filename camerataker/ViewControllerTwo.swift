//
//  ViewControllerTwo.swift
//  camerataker
//
//  Created by Apprentice on 6/14/14.
//  Copyright (c) 2014 Skippers. All rights reserved.
//

import UIKit
import CoreLocation

class ViewControllerTwo: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var myLong = 0.0
    var myLat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
        println(locations[0].coordinate.latitude)
        println(locations[0].coordinate.longitude)
        myLong = locations[0].coordinate.latitude
        myLat = locations[0].coordinate.longitude
    }
    
    @IBOutlet var latitudeLabel : UILabel
    @IBOutlet var longitudeLabel : UILabel
    
    @IBAction func getCurrentLocation(sender : AnyObject) {
        var answerlat = ""
        var answerlong = ""
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
        
        longitudeLabel.text = answerlat
        latitudeLabel.text = answerlong
    }
    
}