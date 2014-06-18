//
//  ViewController.swift
//  camerataker
//
//  Created by Apprentice on 6/14/14.
//  Copyright (c) 2014 Skippers. All rights reserved.
//

import UIKit
import CoreLocation

let CTCheckbuttonSelectedImage = "checkboxgreen"

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var checkButton : UIButton
    // init location manager and set coordinates to 0
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
        
//
//        self.view!.backgroundColor = UIColor.lightGrayColor()
//        var textView = UITextView(frame:CGRectMake(20.0, 80.0, 280.0, 150.0))
//        textView.backgroundColor = UIColor.whiteColor()
//        textView.editable = true
//        textView.selectable = true
//        textView.font = UIFont.systemFontOfSize(15)
//        textView.text = "Tell us about your memory...."
//        self.view.addSubview(textView)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    // standard
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
     // tag textfield and image with variable names
    @IBOutlet var memoryText : UITextView = nil
    @IBOutlet var imageView : UIImageView = nil
    @IBOutlet var textMem : UITextField
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    // textfield delegate removes keyboard when return is hit
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // opens the camera when you git the "Take Photo" button until "Use Photo" is confirmed
    // the the camera closes
    
    @IBOutlet var cameraIcon : UIButton = nil
    
    
    @IBAction func takePhoto(sender : UIButton) {
        
        self.checkButton.setBackgroundImage(UIImage(named: CTCheckbuttonSelectedImage), forState: UIControlState.Normal|UIControlState.Selected|UIControlState.Highlighted)
        self.checkButton.hidden = false;
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    // saves the photo to the variable
//    var imgAsString = ""
//    var img3 = ""
    var myImageData = ""
    
    func imagePickerController(image: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary){
        
        var chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        self.imageView.image = chosenImage
        image.dismissModalViewControllerAnimated(true)
        
        //START TRYING TO POST OUR IMAGE
        var imageData: NSData = UIImageJPEGRepresentation(chosenImage, 0.1)
        
        myImageData = "\(imageData)"
        // TODO: make network request to a shared new
       
    }
    
    // sets the actual long and lat values to the variables and convert to strings with 6 deceimal places
    var once = 1
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
        if once == 1 {
            myLat = locations[0].coordinate.latitude
            myLong = locations[0].coordinate.longitude

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
    
    // submit memory button
    @IBAction func btnCaptureMem(sender : UIButton) {
        // println("Button was clicked")
    
        var myText = textMem.text
        self.view.endEditing(true)
        textMem.text = ""
        imageView.image = nil

        var postString = NSString(format: "text=\(myText)&latitude=\(answerLat)&longitude=\(answerLong)&imagestring=\(myImageData)")
        var postData = postString.dataUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL(string: "http://quiet-ravine-8717.herokuapp.com/memories")
        
        // creating post request
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection.start()
        
        
        // ALERT BUTTON
        let alert = UIAlertView()
        alert.title = "Memory Created!"
        alert.message = "You have shared a memory for the world to experience."
        alert.addButtonWithTitle("the world ♥ you")
        alert.show()
        alert.delegate = nil
    }
}

