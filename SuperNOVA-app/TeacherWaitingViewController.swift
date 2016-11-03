//
//  TeacherWaitingViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Alamofire
import ObjectMapper
import MapKit

class TeacherWaitingMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // GoogleMap
    var lm = CLLocationManager()
    //
    var currentDisplayedPosition: GMSCameraPosition?
    //
    var latitude:   CLLocationDegrees!
    var longitude:  CLLocationDegrees!
    var center: CLLocationCoordinate2D!

    var marker = GMSMarker()
    var mcenter: CLLocationCoordinate2D!
    
    @IBOutlet weak var googleMap: GMSMapView!
    //@IBOutlet weak var MarkerTitle: UILabel!
    //@IBOutlet weak var MarkerImage: UIImageView!
    
    // Google Directions API
    /*
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    
    //var mapTasks = MapTasks()
    */
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 位置情報サービスを開始するかの確認（初回のみ）
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways {
            lm.requestAlwaysAuthorization()
        }
        
        // 初期設定
        initLocationManager();
        latitude  = CLLocationDegrees();
        longitude = CLLocationDegrees();        
        
        // GoogleMapから周辺の地図を取得
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        googleMap.camera = camera;
        googleMap.indoorEnabled = false
        googleMap.setMinZoom(15, maxZoom: 19)
        googleMap.myLocationEnabled = true
        googleMap.settings.myLocationButton = true

        //NSLog("Debug TeacherWatingView test")
        //callWebService()
        //NSLog("Debug TeacherWatingView")
        
        self.view.addSubview(googleMap)
        self.googleMap.delegate = self;
        
    }

    func initLocationManager(){
        
        if #available(iOS 9.0, *){
            lm.allowsBackgroundLocationUpdates = true
        }
        //
        lm.delegate = self
        //
        lm.distanceFilter = appDelegate.distance_filter
        //
        lm.startUpdatingLocation()
    }
    
    
    // 座標が取得できない場合の処理
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        NSLog("Error getting Location")
    }
    // 座標を取得した際の処理
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        // 緯度・経度の取得
        latitude  = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude

        // 中心座標の更新
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        let center = CLLocationCoordinate2DMake(latitude,longitude);
        self.googleMap.animateToCameraPosition(camera)

        callWebService()
        
    
        let mcenter = CLLocationCoordinate2DMake(appDelegate._shoplat,appDelegate._shoplng);
        marker = GMSMarker(position: mcenter)
        marker.icon = UIImage(named: "marker");
        marker.map = self.googleMap
    }

    
    
    @IBAction func checkin(sender: UIButton) {
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toEncounterView")
    }
    
    func callWebService(){
        //let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(18.5235),\(73.7184)&destination=\(18.7603),\(73.8630)&key=AIzaSyDxSgGQX6jrn4iq6dyIWAKEOTneZ3Z8PtU")
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(latitude),\(longitude)&destination=\(appDelegate._shoplat),\(appDelegate._shoplng)&mode=walking&key=\(appDelegate.googleMapsApiKey)")
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            do{
        
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    //print(jsonResult)
                    
                    let routes = jsonResult.valueForKey("routes")
                    //print(routes)
                    
                    let overViewPolyLine = routes![0]["overview_polyline"]!!["points"] as! String
                    //print(overViewPolyLine)
                    
                    if overViewPolyLine != ""{
                        
                        //Call on Main Thread
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.addPolyLineWithEncodedStringInMap(overViewPolyLine)
                        }
                        
                        
                    }
                    
                    
                }
            }
            catch{
                print("Somthing wrong")
            }
        });
        // do whatever you need with the task e.g. run
        task.resume()
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.blueColor()
        polyLine.map = self.googleMap
        
        let smarker = GMSMarker()
        let dmarker = GMSMarker()
        dmarker.position = CLLocationCoordinate2D(latitude: appDelegate._shoplat, longitude: appDelegate._shoplng)
        dmarker.title = appDelegate._shoptitle
        //dmarker.snippet = appDelegate._shopsnippet
        dmarker.map = self.googleMap
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}