//
//  EncounterViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation
import UIKit

class EncounterViewController: UIViewController {
    
    
    @IBOutlet weak var photo_student: UIImageView!
    @IBOutlet weak var photo_teacher: UIImageView!
    @IBOutlet weak var name_student: UILabel!
    @IBOutlet weak var name_teacher: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        //生徒
        self.name_student.text = appDelegate._fullname
        self.photo_student.image =  API.downloadImage(appDelegate._image)
        
        //教師
        UserAPI.getUser(appDelegate._partner,sync: true,
                                  success:{
                                    values in let closure = {
                                        NSLog("---EncounterViewController UserAPI.getUser success");
                                        // 通信は成功したが、エラーが返ってきた場合
                                        if(API.isError(values)){
                                            NSLog("---EncounterViewController UserAPI.getUser isError");
                                            /**
                                             * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                             Indicator.windowClose()
                                             */
                                            AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                message: values["errorMessage"] as! String)
                                            return
                                        }
                                        
                                        NSLog(values.debugDescription);
                                        appDelegate._partnerimage = values["image"] as! String
                                        appDelegate._partnerName = values["fullname"] as! String
                                        self.photo_teacher.image =  API.downloadImage(appDelegate._partnerimage)
                                        self.name_teacher.text = appDelegate._partnerName
                                        
                                    }
                                    // 通知の監視
                                    if(!NSThread.isMainThread()){
                                        NSLog("---EncounterViewController !NSThread.isMainThread() in success");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---EncounterViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---EncounterViewController dispatch_sync else");
                                        // 恐らく実行されない
                                        closure()
                                    }
                                    
            },
                                  failed: {
                                    id, message in let closure = {
                                        NSLog("---EncounterViewController UserAPI.getUser failed");
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
                                        NSLog("---EncounterViewController !NSThread.isMainThread() in failed");
                                        dispatch_sync(dispatch_get_main_queue()) {
                                            NSLog("---EncounterViewController dispatch_sync");
                                            closure()
                                        }
                                    } else {
                                        NSLog("---EncounterViewController dispatch_sync else");
                                        //恐らく実行されない
                                        closure()
                                    }
            }
        )
    }
    
    
    @IBAction func start(sender: UIButton) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        
        //ピッチングの開始時間を更新
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        NSLog(dateFormatter.stringFromDate(now))
        
        let starttime :String! = dateFormatter.stringFromDate(now)
        MergerAPI.updatePitchStarttime(appDelegate._id , starttime: starttime ,sync: true,
                                       success:{
                                        values in let closure = {
                                            NSLog("---EncounterViewController MergerAPI.updatePitchStarttime success");
                                            // 通信は成功したが、エラーが返ってきた場合
                                            if(API.isError(values)){
                                                NSLog("---EncounterViewController MergerAPI.updatePitchStarttime isError");
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
                                            NSLog("---EncounterViewController !NSThread.isMainThread() in success");
                                            dispatch_sync(dispatch_get_main_queue()) {
                                                closure()
                                            }
                                        } else {
                                            NSLog("---EncounterViewController closure");
                                            // 恐らく実行されない
                                            closure()
                                        }
                                        
            },
                                       failed: {
                                        id, message in let closure = {
                                            NSLog("---EncounterViewController MergerAPI.updatePitchStarttime failed");
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
                                            NSLog("---EncounterViewController !NSThread.isMainThread() in failed");
                                            dispatch_sync(dispatch_get_main_queue()) {
                                                NSLog("---EncounterViewController dispatch_sync");
                                                closure()
                                            }
                                        } else {
                                            NSLog("---EncounterViewController dispatch_sync else");
                                            //恐らく実行されない
                                            closure()
                                        }
            }
        )
        
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toConversationView")
        
    }
}
