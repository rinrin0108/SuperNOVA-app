//
//  CallViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    
    @IBAction func change30m(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate._time = "30"
    }
    
    @IBAction func change60m(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate._time = "60"
    }
    
    @IBAction func call(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        if(appDelegate._time == ""){
            appDelegate._time = "30"
        }
        
        // 教師リクエストAPI
        MergerAPI.requestTeacher(appDelegate._userid, lat: appDelegate._lat, lng: appDelegate._lng, lang: appDelegate._lang, place: appDelegate._place ,time:appDelegate._time,sync: false,
                           success:{
                            values in let closure = {
                                NSLog("CallViewController success");
                                // 通信は成功したが、エラーが返ってきた場合
                                if(API.isError(values)){
                                    NSLog("CallViewController isError");
                                    /**
                                     * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                     Indicator.windowClose()
                                     */
                                    AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                        message: values["errorMessage"] as! String)
                                    return
                                }
                                
                                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
                                NSLog(values.debugDescription);
                                appDelegate._id = values["_id"] as! String
                                
                                // 画面遷移
                                ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toWaitingMapView")
                            }
                            // 通知の監視
                            if(!NSThread.isMainThread()){
                                NSLog("CallViewController !NSThread.isMainThread()");
                                dispatch_sync(dispatch_get_main_queue()) {
                                    closure()
                                }
                            } else {
                                NSLog("CallViewController closure");
                                // 恐らく実行されない
                                closure()
                            }
                            
            },
                           failed: {
                            id, message in let closure = {
                                NSLog("CallViewController failed");
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
                                NSLog("CallViewController !NSThread.isMainThread() 2");
                                dispatch_sync(dispatch_get_main_queue()) {
                                    NSLog("CallViewController closure 2");
                                    closure()
                                }
                            } else {
                                NSLog("CallViewController closure 3");
                                //恐らく実行されない
                                closure()
                            }
            }
        )
    }
}