//
//  WaitingMapController.swift
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

class WaitingMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    // GoogleMap
    var lm = CLLocationManager()
    @IBOutlet weak var shopName: UILabel!
    //
    var currentDisplayedPosition: GMSCameraPosition?
    //
    var latitude:   CLLocationDegrees!
    var longitude:  CLLocationDegrees!
    var center: CLLocationCoordinate2D!
    
    var marker = GMSMarker()
    var mcenter: CLLocationCoordinate2D!
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    @IBAction func waiting(sender: UIButton) {
        NSLog("---waiting");
        
        // 教師リクエストAPI
        MergerAPI.requestTeacher(appDelegate._userid, lat: appDelegate._lat, lng: appDelegate._lng, lang: appDelegate._lang, place: appDelegate._place ,time:appDelegate._time,sync: true,
                                 success:{
                                    values in let closure = {
                                        NSLog("---CallViewController MergerAPI.requestTeacher success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("---CallViewController MergerAPI.requestTeacher isError");
                                            /**
                                             * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                             Indicator.windowClose()
                                             */
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: values["errorMessage"] as! String)
                                            return
                                        }
                                        
                                        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
                                        NSLog(values.debugDescription);
                                        appDelegate._id = values["_id"] as! String
                                        
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("---CallViewController !NSThread.isMainThread() in success");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            closure()
                                        }
                                    } else {
                                        NSLog("---CallViewController closure");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                 failed: {
                                    id, message in let closure = {
                                        NSLog("---CallViewController MergerAPI.requestTeacher failed");
                                        /**
                                         * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                         Indicator.windowClose()
                                         */
                                        // 失敗した場合エラー情報を表示
                                        if(id == -2) {
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: NSLocalizedString("MAX_FILE_SIZE_OVER", comment: ""));
                                        } else {
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: NSLocalizedString("ALERT_MESSAGE_NETWORK_ERROR", comment: ""));
                                        }
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("---CallViewController !NSThread.isMainThread() in failed");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---CallViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---CallViewController dispatch_sync else");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )
        
        
        NSLog("---waiting2");
        
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        NSLog(dateFormatter.stringFromDate(now))
        var flg = false;
        
        var flg4api = true;
        //ポーリング
        for(var i=0;i<10;i++){
            NSLog(dateFormatter.stringFromDate(now))
            NSThread.sleepForTimeInterval(1)
            
            if(flg4api){
                
            //リクエスト状況を取得
            MergerAPI.getRequestStatus(appDelegate._id ,sync: true,
                                       success:{
                                        values in let closure = {
                                            NSLog("---CallViewController success");
                                            // 通信は成功したが、エラーが返ってきた場合
                                            if(API.isError(values)){
                                                NSLog("---CallViewController isError");
                                                /**
                                                 * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                                 Indicator.windowClose()
                                                 */
                                                AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                    message: values["errorMessage"] as! String)
                                                return
                                            }
                                            
                                            NSLog(values.debugDescription);
                                            self.appDelegate._partner = values["teacher"] as! String
                                            if(values["status"] as! String! == "res"){
                                                flg = true
                                                flg4api = false
                                                NSLog("toEncounterView")
                                                ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toEncounterView")
                                            }
                                            
                                        }
                                        // 通知の監視
                                        if(!NSThread.isMainThread()){
                                            NSLog("---CallViewController !NSThread.isMainThread()");
                                            dispatch_sync(dispatch_get_main_queue()) {
                                                closure()
                                            }
                                        } else {
                                            NSLog("---CallViewController closure");
                                            // 恐らく実行されない
                                            closure()
                                        }
                                        
                },
                                       failed: {
                                        id, message in let closure = {
                                            NSLog("---CallViewController failed");
                                            /**
                                             * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                             Indicator.windowClose()
                                             */
                                            // 失敗した場合エラー情報を表示
                                            if(id == -2) {
                                                AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                    message: NSLocalizedString("MAX_FILE_SIZE_OVER", comment: ""));
                                            } else {
                                                AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                    message: NSLocalizedString("ALERT_MESSAGE_NETWORK_ERROR", comment: ""));
                                            }
                                            ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toMapView")
                                        }
                                        // 通知の監視
                                        if(!NSThread.isMainThread()){
                                            NSLog("---CallViewController !NSThread.isMainThread() 2");
                                            dispatch_sync(dispatch_get_main_queue()) {
                                                NSLog("---CallViewController closure 2");
                                                closure()
                                            }
                                        } else {
                                            NSLog("---CallViewController closure 3");
                                            //恐らく実行されない
                                            closure()
                                        }
                }
            )
            }

            
            
        }
        if(flg){
        } else {
            ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toMapView")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func initLocationManager() {
        if #available(iOS 9.0, *) {
            lm.allowsBackgroundLocationUpdates = true
        }
        lm.delegate = self
        lm.distanceFilter = appDelegate.distance_filter
        
        lm.startUpdatingLocation()
    }
    
    // 座標が取得できない場合の処理
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error getting Location")
    }
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        let center = CLLocationCoordinate2DMake(latitude,longitude);
        self.googleMap.animateToCameraPosition(camera)
        
        callWebService()
        
        let mcenter = CLLocationCoordinate2DMake(appDelegate._shoplat,appDelegate._shoplng);
        marker = GMSMarker(position: mcenter)
        marker.icon = UIImage(named: "marker");
        marker.map = self.googleMap
        
    }
    func callWebService(){
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
        
        shopName.text = appDelegate._shoptitle
    }


    
}