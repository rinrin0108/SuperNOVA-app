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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 位置情報サービスを開始するかの確認（初回のみ）
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways {
            lm.requestAlwaysAuthorization()
        }
        
        // 初期設定
        initLocationManager();
        
        latitude = 35.698353;
        longitude = 139.773114;
        
        
        // GoogleMapから周辺の地図を取得
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        googleMap.camera = camera;
        googleMap.indoorEnabled = false
        googleMap.setMinZoom(15, maxZoom: 19)
        googleMap.myLocationEnabled = true
        googleMap.settings.myLocationButton = true
        
        NSLog("Debug TeacherWatingView")
        
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

    
        let mcenter = CLLocationCoordinate2DMake(appDelegate._shoplat,appDelegate._shoplng);
        marker = GMSMarker(position: mcenter)
        marker.icon = UIImage(named: "marker");
        marker.map = self.googleMap
    }

    
    
    @IBAction func checkin(sender: UIButton) {
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toEncounterView")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}