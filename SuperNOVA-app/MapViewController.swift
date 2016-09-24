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
    var center = CLLocationCoordinate2DMake(35.698353,139.773114)
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        //self.googleMap.delegate = self;
        
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
        
        var mposition = CLLocationCoordinate2DMake(lat,lon)
        var marker = GMSMarker()
        //marker.title = "test"
        //marker.icon = UIImage(named: "marker")
        //marker.map = self.googleMap

      
        //NSLog("marker:\(marker)")
        
        var page_token:String = ""
        
        repeat {
            let semaphore = dispatch_semaphore_create(0)
            
            //検索URLの作成
            let encodedStr = "cafes".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=2000&sensor=true&key=\(appDelegate.googleMapsApiKey)&name=\(encodedStr!)&pagetoken=\(page_token)"
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
                                    
                                    //ビンの座標を設定する。
                                    mposition = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["lng"] as! CLLocationDegrees)
                                    NSLog("lat:\(mposition.latitude),lot:\(mposition.longitude)")
                                    NSLog("result:\(result)")
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

        
        /*
        var annotationList = [MKPointAnnotation]()
        var page_token:String = ""
        
        repeat {
            //
            let semaphore = dispatch_semaphore_create(0)
            
            //検索URLの作成
            let encodedStr = "cafe".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(center.latitude),\(center.longitude)&radius=2000&sensor=true&key=\(appDelegate.googleMapsApiKey)&name=\(encodedStr!)&pagetoken=\(page_token)"
            let searchNSURL = NSURL(string: url)
            
            //検索を実行する。
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            session.dataTaskWithURL(searchNSURL!, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                
                if error != nil {
                    print("エラーが発生しました。\(error)")
                } else {
                    if let statusCode = response as? NSHTTPURLResponse {
                        if statusCode.statusCode != 200 {
                            print("サーバーから期待するレスポインスが来ませんでした。\(response)")
                        }
                    }
                    
                    do {
                        //レスポンスデータ（JSON）から辞書を作成する。
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        let results = json["results"] as? Array<NSDictionary>
                        
                        //次のページがあるか確認する。
                        if json["next_page_token"] != nil {
                            page_token = json["next_page_token"] as! String
                        } else {
                            page_token = ""
                        }
                        
                        //検索結果の件数ぶんループ
                        for result in results! {
                            
                            let annotation = MKPointAnnotation()
                            
                            //ピンのタイトルに店名、住所を設定する。
                            annotation.title = result["name"] as? String
                            annotation.subtitle = result["vicinity"] as? String
                            
                            if let geometry = result["geometry"] as? NSDictionary {
                                if let location = geometry["location"] as? NSDictionary {
                                    
                                    //ビンの座標を設定する。
                                    annotation.coordinate = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["lng"] as! CLLocationDegrees)
                                    annotationList.append(annotation)
                                    
                                }
                            }
                        }
                    } catch {
                        print("エラー")
                    }
                }
                //連続で要求をすると結果が返ってこないので一瞬スリープする。
                sleep(1)
                
                //処理終了をセマフォに知らせる。
                dispatch_semaphore_signal(semaphore)
                
            }).resume()
            
            //検索が終わるのを待つ。
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        } while (page_token != "")
        
        
        //ピンをマップに追加する。
        googleMap.addAnnotations(annotationList)
        */
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}