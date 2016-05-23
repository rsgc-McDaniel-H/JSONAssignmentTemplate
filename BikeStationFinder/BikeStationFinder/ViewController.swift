//
//  ViewController.swift
//  BikeStationFinder
//
//  Created by Student on 2016-05-18.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController : UIViewController, CLLocationManagerDelegate {
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    var locationManager : CLLocationManager = CLLocationManager()
    var latitude : String = ""
    var longitude : String = ""
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
       // var locationManager : CLLocationManager = CLLocationManager()
        
       
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // http://feeds.bikesharetoronto.com/stations/stations.json
            //
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments)as! AnyObject
            
            // Now we can update the UI
            // (must be done asynchronously)
            
            
            if let stationData = json as? [String: AnyObject] {
                print("stationData is: \(stationData["executionTime"])")
            } else {
                print("could not parse station data")
            }
            
            if let beanList = json as? AnyObject {
                //print("beanList is: \(beanList["stationBeanList"])")
                
                if let beans = beanList["stationBeanList"] as? [AnyObject] {
                    
                    for bean in beans {
                        
                        if let stationDetails = bean as? [String: AnyObject]{
                            
                            //print("station name is \(stationDetails["stationName"])")
                            guard let stationName : String = stationDetails["stationName"] as? String,
                                
                                 let bikes : Double = stationDetails["availableBikes"] as? Double,
                               
                                let availibility : String = stationDetails["statusValue"] as?
                                String,
                                let stationLatitude : Double = stationDetails["latitude"] as? Double,
                                let stationLongitude : Double = stationDetails["longitude"]
                                as? Double,
                                let Time : String  = stationDetails["lastCommunicationTime"] as? String
                            
                              //  let lastCommunicationTime : Double = stationDetails["Docks"] as? Double
                    
                               // as? Double
                            
                                else {
                                    print("Error loading")
                                    return
                            }
                            //print("That are \(lastCommunicationTime)"
                            print("The station is \(availibility)")
                            print("The amount of available bikes are \(bikes)")
                            print("The last communication time was \(Time)")
                            print("station Name is \(stationName)")
                            print("latitude is \(stationLatitude)")
                            print("longitude is \(stationLongitude)")
                            
                            // Now we can update the UI
                            // (must be done asynchronously)
                            
                            if stationName == "Jarvis St / Carlton St" {
                                print("inside if statement Ted Rogers Way")
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    var infoToShow : String = "Information For your Station Retrieved\n\n."
                                    infoToShow += "The Station is: \(availibility).\n"
                                     infoToShow += "The amount of available bikes are : \(bikes).\n"
                                    infoToShow += "The last check was at : \(Time).\n"
                                     infoToShow += "Your Favorite Station is : \(stationName).\n"

                                    infoToShow += "Yor favorite station's latitude is: \(stationLatitude).\n"
                                    infoToShow += "Yor favorite station's longitude is: \(stationLongitude).\n"
                                    infoToShow += "Your latitude is: \(self.latitude).\n"
                                    infoToShow += "Your longitude is: \(self.longitude).\n"
                                  //  infoToShow += "Station is: \(statusValue).\n"
                                    
                                    self.jsonResult.text = infoToShow
                                    
                                }

                            }
                            
                        }
                
                    }
                    
                }
                
                
            } else {
                print("error retreving bean list ")
            }
            
           
           
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        let address : String = "http://feeds.bikesharetoronto.com/stations/stations.json"
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()
    
        
        // Make the view's background be gray
        view.backgroundColor = UIColor.lightGrayColor()
        
        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
    
        jsonResult.text = "Information will load here"
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Get my Bike Station Information", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonResult,
            "getData": getData]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[getData][title]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
        /*
         * Location services setup
         */
        // What class is the delegate for CLLocationManager? (By passing "self" we are saying it is this view controller)
        locationManager.delegate = self
        // Set the level of location accuracy desired
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Prompt the user for permission to obtain their location when the app is running
        // NOTE: Must add these values to the Info.plist file in the project
        // 	  <key>NSLocationWhenInUseUsageDescription</key>
        //    <string>The application uses this information to find the cooling centre nearest you.</string>
        locationManager.requestWhenInUseAuthorization()
        // Now try to obtain the user's location (this runs aychronously)
        locationManager.startUpdatingLocation()
       
        
    }
    // Required method for CLLocationManagerDelegate
    // This method runs when the location of the user has been updated.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // We now have the user's location, so stop finding their location.
        // (Looking for current location is a battery drain)
        self.locationManager.stopUpdatingLocation()
        
        // Set the most recent location found
        let latestLocation = locations.last
        
        // Format the current location as strings with four decimal places of accuracy
        latitude = String(format: "%.4f", latestLocation!.coordinate.latitude)
        longitude = String(format: "%.4f", latestLocation!.coordinate.longitude)
        
        // Report the location
        print("Location obtained at startup...")
        print("Latitude: \(latitude)")
        print("Longitude: \(longitude)")
    }
    // Required method for CLLocationManagerDelegate
    // This method will be run when there is an error determing the user's location
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // Report the error
        print("didFailWithError \(error)")
        
    }
    
}

