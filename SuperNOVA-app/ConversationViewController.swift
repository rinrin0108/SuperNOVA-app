//
//  ConversationViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController {
    
    
    @IBOutlet weak var photo_student: UIImageView!
    @IBOutlet weak var photo_teacher: UIImageView!
    @IBOutlet weak var name_teacher: UILabel!
    @IBOutlet weak var name_student: UILabel!
    
    override func viewDidLoad() {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        //生徒
        self.name_student.text = appDelegate._fullname
        self.photo_student.image =  API.downloadImage(appDelegate._image)
        //教師
        self.name_teacher.text = appDelegate._partnerName
        self.photo_teacher.image =  API.downloadImage(appDelegate._partnerimage)

    }
    
    @IBAction func start(sender: UIButton) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        //ピッチング終了リクエスト
        MergerAPI.finishPitching(appDelegate._id ,sync: false,
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

        
        
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toEvaluateView")
    }
}