//
//  WaitingMapController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation
import UIKit

class WaitingMapViewController: UIViewController {
    
    @IBAction func waiting(sender: UIButton) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        NSLog(dateFormatter.stringFromDate(now))
        
        //ポーリング
        for(var i=0;i<10;i++){
            NSLog(dateFormatter.stringFromDate(now))
            NSThread.sleepForTimeInterval(3)
            
            //リクエスト状況を取得
            MergerAPI.getRequestStatus(appDelegate._id ,sync: false,
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
                                            
                                            NSLog(values.debugDescription);
                                            appDelegate._partner = values["teacher"] as! String
                                            NSLog("yaaaaaaaaa")
                                            NSLog(values["status"] as! String!)
                                            NSLog("yaaaaaaaaa")
                                            if(values["status"] as! String! == "res"){
                                                ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toEncounterView")
                                            }
                                            
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
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toMapView")
    }
    
    override func viewDidLoad() {
    }
    
}