//
//  MapViewController.swift
//  SuperNOVA-app
//
//  Created by y-okada on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import ObjectMapper
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    // GoogleMap
    var lm = CLLocationManager()
    //
    var currentDisplayedPosition: GMSCameraPosition?
    //
    var latitude:   CLLocationDegrees! =  35.698353
    var longitude:  CLLocationDegrees! = 139.773114
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 位置情報サービスを開始するかの確認
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways {
            lm.requestAlwaysAuthorization()
        }

        //
        initLocationManager();

        //
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        googleMap.camera = camera;
        googleMap.indoorEnabled = false
        googleMap.setMinZoom(15, maxZoom: 19)
        googleMap.myLocationEnabled = true
        googleMap.settings.myLocationButton = true
        
        // The myLocation attribute of the mapView may be null
        if let mylocation = googleMap.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        self.view.addSubview(googleMap)
        //self.googleMap.delegate = self;
        
    }
    
    
    func initLocationManager(){
        //lm = CLLocationManager()
        
        if #available(iOS 9.0, *){
            lm.allowsBackgroundLocationUpdates = true
        }
        //
        lm.delegate = self
        //
        //lm.distanceFilter = appDelegate.distance_filter
        //
        lm.startUpdatingLocation()
    }


    //
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        NSLog("Error getting Location")
    }
    //
 
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        //
        latitude  = newLocation.coordinate.latitude
        //
        longitude = newLocation.coordinate.longitude
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        self.googleMap.animateToCameraPosition(camera)
        //
        NSLog("latitude: \(latitude), longitude: \(longitude)");
    }
    /*
    internal func onClickLocationButton(sender: UIButton){
        googleMap.animateToLocation(CLLocationCoordinate2DMake(self.latitude, self.longitude))
    }
     */
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}