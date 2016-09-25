//
//  EvaluateViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation
import UIKit

class EvaluateViewController: UIViewController {
    
    @IBAction func rate(sender: UIButton) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        var rate : String! = "3"
        
        //ピッチング終了リクエスト
        UserAPI.updateUserRate(appDelegate._teacher,rate: rate ,sync: false,
                                 success:{
                                    values in let closure = {
                                        NSLog("EvaluateViewController success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("EvaluateViewController isError");
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
                                        NSLog("EvaluateViewController !NSThread.isMainThread()");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            closure()
                                        }
                                    } else {
                                        NSLog("EvaluateViewController closure");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                 failed: {
                                    id, message in let closure = {
                                        NSLog("EvaluateViewController failed");
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
                                        NSLog("EvaluateViewController !NSThread.isMainThread() 2");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("EvaluateViewController closure 2");
                                            closure()
                                        }
                                    } else {
                                        NSLog("EvaluateViewController closure 3");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )

        
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toMapView")
    }
}
