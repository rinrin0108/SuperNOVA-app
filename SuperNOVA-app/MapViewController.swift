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
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        MergerAPI.responseTeacher(appDelegate._userid, _id: appDelegate._idpartner ,sync: true,
                                   success:{
                                    values in let closure = {
                                        NSLog("---MapViewController MergerAPI.responseTeacher success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("---MapViewController MergerAPI.responseTeacher isError");
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
                                        NSLog("---MapViewController !NSThread.isMainThread() in success");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---MapViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---MapViewController dispatch_sync else");
                                        // 恐らく実行されない
                                        closure()
                                    }
            },
                                   failed: {
                                    id, message in let closure = {
                                        NSLog("---MapViewController MergerAPI.responseTeacher failed");
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
                                        NSLog("---MapViewController !NSThread.isMainThread() in failed");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---MapViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---MapViewController dispatch_sync else");
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
    //var latitude:   CLLocationDegrees! =  35.698353
    //var longitude:  CLLocationDegrees! = 139.773114
    //var center = CLLocationCoordinate2DMake(35.698353,139.773114)
    var latitude:   CLLocationDegrees!
    var longitude:  CLLocationDegrees!
    var center: CLLocationCoordinate2D!
    var radius = 150;
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var MarkerTitle: UILabel!
    @IBOutlet weak var MarkerImage: UIImageView!


    //@IBOutlet weak var UserProf: UIImageView! = API.downloadImage(appDelegate._image)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //更新された位置情報を元にした検索
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(MapViewController.searchRequest), userInfo: nil, repeats: true)
        
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
        
        // 周辺施設の表示
//        searchAroudMe(self.googleMap, lat:latitude, lon:longitude);
        
        self.view.addSubview(googleMap)
        self.googleMap.delegate = self;
        
    }
    
    func searchRequest() {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        appDelegate._place = "SHOP01";
        
        if (appDelegate._lat == nil || appDelegate._lng == nil){
            appDelegate._lat = "35.698353";
            appDelegate._lng = "139.773114";
        }
        
        NSLog("---MapViewController searchRequest lat:" + appDelegate._lat + " lng:" + appDelegate._lng);
        
        UserAPI.updateUserLocation(appDelegate._userid, lat: appDelegate._lat, lng: appDelegate._lng ,sync: true,
                                   success:{
                                    values in let closure = {
                                        NSLog("---MapViewController UserAPI.updateUserLocation success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("---MapViewController UserAPI.updateUserLocation isError");
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
                                        NSLog("---MapViewController !NSThread.isMainThread() in success");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---MapViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---MapViewController dispatch_sync else");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                   failed: {
                                    id, message in let closure = {
                                        NSLog("---MapViewController UserAPI.updateUserLocation failed");
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
                                        NSLog("---MapViewController !NSThread.isMainThread() in failed");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---MapViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---MapViewController dispatch_sync else");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )
        
        

        //近辺の
        MergerAPI.searchRequest(appDelegate._lat,lng: appDelegate._lng,lang: appDelegate._native ,sync: true,
                                   success:{
                                    values in let closure = {
                                        NSLog("---MapViewController MergerAPI.searchRequest success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("---MapViewController MergerAPI.searchRequest isError");
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
                                        if(values["status"] as! String == "req"){
                                            
                                            //初回
                                            if(appDelegate._pushId != nil){
                                                if(appDelegate._pushId == values["_id"] as! String){
                                                    return
                                                }
                                            }
                                            
                                            appDelegate._pushId = values["_id"] as! String
                                            
                                            //ローカル通知
                                            let notification = UILocalNotification()
                                            //ロック中にスライドで〜〜のところの文字
                                            notification.alertAction = "アプリを開く"
                                            //通知の本文
                                            notification.alertBody = "リクエストを受信中です！"
                                            //通知される時間（とりあえず5秒後に設定）
                                            notification.fireDate = NSDate(timeIntervalSinceNow:1)
                                            //通知音
                                            notification.soundName = UILocalNotificationDefaultSoundName
                                            //アインコンバッジの数字
                                            //notification.applicationIconBadgeNumber = 1
                                            //通知を識別するID
                                            notification.userInfo = ["notifyID":"SuperNova"]
                                            //通知をスケジューリング
                                            appDelegate._application.scheduleLocalNotification(notification)
                                        }
                                        
                                        
                                        NSLog(values.debugDescription);
                                        appDelegate._partner = values["student"] as! String;
                                        appDelegate._idpartner = values["_id"] as! String;
                                        
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("---MapViewController !NSThread.isMainThread()");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            closure()
                                        }
                                    } else {
                                        NSLog("---MapViewController closure");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                   failed: {
                                    id, message in let closure = {
                                        NSLog("---MapViewController MergerAPI.searchRequest failed");
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
                                        NSLog("---MapViewController !NSThread.isMainThread() 2");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---MapViewController closure 2");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---MapViewController closure 3");
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
        let center = CLLocationCoordinate2DMake(latitude,longitude);
        self.googleMap.animateToCameraPosition(camera)

        searchAroudMe(self.googleMap, lat:latitude, lon:longitude);
        
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
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=\(radius)&sensor=true&key=\(appDelegate.googleMapsApiKey)&name=\(encodedStr!)&pagetoken=\(page_token)"
            let searchNSURL = NSURL(string: url)
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            session.dataTaskWithURL(searchNSURL!, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                
                if error != nil {
                    NSLog("エラーが発生しました。\(error)")
                } else {
                    if let statusCode = response as? NSHTTPURLResponse {
                        if statusCode.statusCode != 200 {
                            NSLog("サーバから期待するレスポンスが来ませんでした。\(response)")
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
                                        //NSLog("result:\(result)")
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
                        NSLog("error")
                    }
                }
                sleep(1)
                dispatch_semaphore_signal(semaphore)
            }).resume()
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        } while (page_token != "")
        
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        //NSLog("marker:\(marker)")
        //NSLog("title:\(marker.title)")
        //NSLog("icon :\(marker.icon)")
        MarkerTitle.text = marker.title
        MarkerImage.image = marker.icon
        appDelegate._shoplat = marker.position.latitude
        appDelegate._shoplng = marker.position.longitude
        appDelegate._shoptitle = marker.title
        
        //self.view.addSubview(mapView)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
