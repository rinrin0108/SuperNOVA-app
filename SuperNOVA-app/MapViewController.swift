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
    
    
    @IBOutlet weak var push_icon: UIImageView!
    @IBOutlet weak var push_text: UILabel!
    
    @IBOutlet weak var responseTeacher: UIButton!
    @IBAction func responseTeacher(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        MergerAPI.responseTeacher(appDelegate._userid, _id: appDelegate._idpartner ,sync: false,
                                   success:{
                                    values in let closure = {
                                        NSLog("ConversationViewController success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("ConversationViewController isError");
                                            /**
                                             * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                             Indicator.windowClos()
                                             
                                             */
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: values["errorMessage"] as! String)
                                            return
                                        }
                                        
                                        NSLog(values.debugDescription);
                                        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toTeacherWaitingView")
                                        
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("ConversationViewController !NSThread.isMainThread()");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            closure()
                                        }
                                    } else {
                                        NSLog("ConversationViewController closure");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                   failed: {
                                    id, message in let closure = {
                                        NSLog("ConversationViewController failed");
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
                                        NSLog("ConversationViewController !NSThread.isMainThread() 2");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("ConversationViewController closure 2");
                                            closure()
                                        }
                                    } else {
                                        NSLog("ConversationViewController closure 3");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )
        

        
    }
    
    
    @IBAction func goAppoint(sender: UIButton) {
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toCallView")
    }
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
    var center = CLLocationCoordinate2DMake(35.698353,139.773114)
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var MarkerTitle: UILabel!
    @IBOutlet weak var MarkerImage: UIImageView!


    //@IBOutlet weak var UserProf: UIImageView! = API.downloadImage(appDelegate._image)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(MapViewController.searchRequest), userInfo: nil, repeats: true)
        
        // 位置情報サービスを開始するかの確認（初回のみ）
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways {
            lm.requestAlwaysAuthorization()
        }

        // 初期設定
        initLocationManager();

        // GoogleMapから周辺の地図を取得
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: appDelegate.zoom)
        googleMap.camera = camera;
        googleMap.indoorEnabled = false
        googleMap.setMinZoom(15, maxZoom: 19)
        googleMap.myLocationEnabled = true
        googleMap.settings.myLocationButton = true
        
        // 周辺施設の表示
        //searchAroudMe(self.googleMap, lat:latitude, lon:longitude);
        
        self.view.addSubview(googleMap)
        self.googleMap.delegate = self;
        
    }
    
    func searchRequest() {
        NSLog("searchRequest timer")
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        appDelegate._place = "SHOP01";
        //FIXME
        appDelegate._lat = "35.698353";
        appDelegate._lng = "139.773114";
        
        UserAPI.updateUserLocation(appDelegate._userid, lat: appDelegate._lat, lng: appDelegate._lng ,sync: false,
                                   success:{
                                    values in let closure = {
                                        NSLog("MapViewController success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("MapViewController isError");
                                            /**
                                             * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                             Indicator.windowClose()
                                             */
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: values["errorMessage"] as! String)
                                            return
                                        }
                                        
                                        NSLog(values.debugDescription);
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("MapViewController !NSThread.isMainThread()");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            closure()
                                        }
                                    } else {
                                        NSLog("MapViewController closure");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                   failed: {
                                    id, message in let closure = {
                                        NSLog("MapViewController failed");
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
                                        NSLog("MapViewController !NSThread.isMainThread() 2");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("MapViewController closure 2");
                                            closure()
                                        }
                                    } else {
                                        NSLog("MapViewController closure 3");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )
        
        

        //近辺の
        MergerAPI.searchRequest(appDelegate._lat,lng: appDelegate._lng,lang: appDelegate._native ,sync: false,
                                   success:{
                                    values in let closure = {
                                        NSLog("ConversationViewController success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("ConversationViewController isError");
                                            /**
                                             * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                             Indicator.windowClose()
                                             */
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: values["errorMessage"] as! String)
                                            return
                                        }
                                        if(values.isEmpty){
                                            return
                                        }
                                        
                                        NSLog(values.debugDescription);
                                        appDelegate._partner = values["student"] as! String;
                                        appDelegate._idpartner = values["_id"] as! String;
                                        
                                        NSLog("uryyyyy")
                                        NSLog(appDelegate._idpartner)
                                        NSLog("uryyyyy")
                                        
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("ConversationViewController !NSThread.isMainThread()");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            closure()
                                        }
                                    } else {
                                        NSLog("ConversationViewController closure");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                   failed: {
                                    id, message in let closure = {
                                        NSLog("ConversationViewController failed");
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
                                        NSLog("ConversationViewController !NSThread.isMainThread() 2");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("ConversationViewController closure 2");
                                            closure()
                                        }
                                    } else {
                                        NSLog("ConversationViewController closure 3");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )
        
        
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
        center = CLLocationCoordinate2DMake(latitude,longitude);
        self.googleMap.animateToCameraPosition(camera)

        searchAroudMe(self.googleMap, lat:latitude, lon:longitude);
        // Debug
        //NSLog("latitude: \(latitude), longitude: \(longitude)");
    }
    /*
    internal func onClickLocationButton(sender: UIButton){
        googleMap.animateToLocation(CLLocationCoordinate2DMake(self.latitude, self.longitude))
    }
     */
 
    // 周辺施設呼び出しメソッド
    func searchAroudMe(mapView:GMSMapView,lat:CLLocationDegrees,lon:CLLocationDegrees) {
        
        var mposition : CLLocationCoordinate2D
        var marker = GMSMarker()
        var page_token:String = ""
        
        repeat {
            let semaphore = dispatch_semaphore_create(0)
            
            //検索URLの作成
            let encodedStr = "cafes".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=50&sensor=true&key=\(appDelegate.googleMapsApiKey)&name=\(encodedStr!)&pagetoken=\(page_token)"
            let searchNSURL = NSURL(string: url)
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            session.dataTaskWithURL(searchNSURL!, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                
                if error != nil {
                    print("エラーが発生しました。\(error)")
                } else {
                    if let statusCode = response as? NSHTTPURLResponse {
                        if statusCode.statusCode != 200 {
                            print("サーバから期待するレスポンスが来ませんでした。\(response)")
                        }
                    }
                
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        let results = json["results"] as? Array<NSDictionary>
                    
                        //次のページがあるか確認する。
                        if json["next_page_token"] != nil {
                            page_token = json["next_page_token"] as! String
                        } else {
                            page_token = ""
                        }
                        
                        for result in results! {
                            if let geometry = result["geometry"] as? NSDictionary {
                                if let location = geometry["location"] as? NSDictionary {
                                    
                                    //ビンの座標を設定する
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NSLog("result:\(result)")
                                        let mposition = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["lng"] as! CLLocationDegrees)
                                        
                                        marker = GMSMarker(position: mposition)
                                        marker.title = result["name"] as? String
                                        //let tmpurl = NSURL(string: result["icon"]);
                                        let tmpurl = result["icon"]
                                        
                                        //var err: NSError?
                                        let imageData :NSData = NSData(contentsOfURL: NSURL(string: tmpurl! as! String)! )!;
                                        
                                        
                                        marker.icon = UIImage(data:imageData);//UIImage//UIImage(named: "marker")
                                        marker.map = self.googleMap

                                    });
                                }
                            }
                        }
                    } catch {
                        print("error")
                    }
                }
                sleep(1)
                dispatch_semaphore_signal(semaphore)
            }).resume()
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        } while (page_token != "")
        
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        NSLog("marker:\(marker)")
        NSLog("title:\(marker.title)")
        NSLog("icon :\(marker.icon)")
        MarkerTitle.text = marker.title
        MarkerImage.image = marker.icon
        
        //self.view.addSubview(mapView)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
