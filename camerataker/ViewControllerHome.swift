//
//  ViewControllerHome.swift
//  camerataker
//
//  Created by Apprentice on 6/16/14.
//  Copyright (c) 2014 Skippers. All rights reserved.
//

import UIKit
import CoreLocation

class ViewControllerHome: UIViewController, UINavigationControllerDelegate , UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet var changeMemWait : UILabel
    var myLong = 0.0
    var myLat = 0.0
    var answerLat = ""
    var answerLong = ""
    var once = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // first function we need to define and nest
//    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
//        println("test1")
//        if once == 1 {
//            println("test2")
//            myLat = locations[0].coordinate.latitude
//            myLong = locations[0].coordinate.longitude * -1  //SEE IF WE CAN FIX THIS THROUGH THE API
//            println(myLat)
//            println(myLong)
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
//    // second function we need to define and nest
//    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
//        println("popl")
//        var getText = ""
//        var getUrl = ""
//        
//        if data.length == 4 {
//            
//        }
//        else {
//            changeMemWait.text = "(a memory is waiting for you)!!!!"
//        }
//    }
//
//
//    // function that will run every minute with the functions defined above nested below
//    func update() {
//        println("test0")
//        locationManager(manager: CLLocationManager?, didUpdateLocations: AnyObject[])
//        
//        if true {
//
//            var url = NSURL(string: "http://young-beach-6740.herokuapp.com/memories?latitude=\(answerLat)&longitude=\(answerLong)")
//            println(url)
//            
//            var request = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "GET"
//            request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
//            
//            var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
//            connection.start()
//        }
//    
//        connection(connection: connection, didReceiveData: data)
//        
//    }
    
}

