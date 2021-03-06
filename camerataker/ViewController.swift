//
//  ViewController.swift
//  camerataker
//
//  Created by Apprentice on 6/14/14.
//  Copyright (c) 2014 Skippers. All rights reserved.
//  

import UIKit
import CoreLocation



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    // init location manager and set coordinates to 0
    let locationManager = CLLocationManager()
    var myLong = 0.0
    var myLat = 0.0
    var answerLat = ""
    var answerLong = ""
    
    // after the view loads, start getting location
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController.navigationBar.hidden = false;
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        textMem.layer.borderWidth = 0.6
        textMem.layer.cornerRadius = 6.0
        textMem.scrollEnabled = true
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
    @IBOutlet var imageView : UIImageView = nil
    @IBOutlet var textMem : UITextView = nil
    @IBOutlet var changeError : UILabel = nil
    @IBOutlet var checkButtonChangeColor : UIButton
    
    
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
    @IBAction func takePhoto(sender : UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    //Initialize camera data string
    func imagePickerController(image: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        var chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        self.imageView.image = chosenImage
        self.dismissModalViewControllerAnimated(true)
        var imageData: NSData = UIImageJPEGRepresentation(chosenImage, 0.1)
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
        if (imageView.image == nil) {changeError.text="Please enter both text and an image to submit"}
        else if (textMem.text == "") {changeError.text="Please enter both text and an image to submit"}
        else {
            var myText = textMem.text
            self.view.endEditing(true)
            
            var url = "http://nameless-reaches-8687.herokuapp.com/memories"
            
            let manager = AFHTTPRequestOperationManager()
            let params = ["text":myText, "latitude":answerLat, "longitude":answerLong]
            
            manager.POST(url, parameters: params,
                constructingBodyWithBlock: {
                    [weak self](formData) -> Void in
                    formData.appendPartWithFileData(UIImageJPEGRepresentation(self?.imageView?.image, 0.9), name: "image", fileName: "picture.jpg", mimeType: "image/jpeg")
                },
                success: {(operation, response) -> Void in
                    println(response)
                },
                failure: {(operation, response) -> Void in
                    println(response)
                })
            
            let alert = UIAlertView()
            alert.title = "Memory Created!"
            alert.message = "You have shared a memory for the world to experience."
            alert.addButtonWithTitle("the world ♥'s you")
            alert.show()
            alert.delegate = nil
            
            textMem.text = ""
            imageView.image = nil
            changeError.text=""
            }
    }
}