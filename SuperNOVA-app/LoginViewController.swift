//
//  LoginViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        //キャッシュを消す
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        NSURLCache.sharedURLCache().diskCapacity = 0
        NSURLCache.sharedURLCache().memoryCapacity = 0
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得

        appDelegate._id = "";
    }
    
    /**
     * ログインボタン押下時
     **/
    @IBAction func pushLogin(sender: UIButton) {
        NSLog("---LoginViewController pushLogin");
        //ログイン認証を行う
        let login : FBSDKLoginManager = FBSDKLoginManager.init()
        login.logInWithReadPermissions(["public_profile", "email"], fromViewController: self,
                                       handler: {
                                        result, error in
                                        let closure = {
                                            if ((error) != nil)
                                            {
                                                NSLog("---LoginViewController pushLogin error");
                                                NSLog(error.description);
                                                // 失敗した場合エラー情報を表示
                                                AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                                    message: NSLocalizedString("ALERT_LOGIN_FAILED_ERROR", comment: ""));
                                            } else if !result.isCancelled {
                                                NSLog("---LoginViewController success");
                                                //ログインが成功
                                                ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toUserRegisterView")
                                            }
                                        }
                                        
                                        // 通知の監視
                                        if(!NSThread.isMainThread()){
                                            NSLog("---LoginViewController !NSThread.isMainThread()");
                                            dispatch_sync(dispatch_get_main_queue()) {
                                                NSLog("---LoginViewController dispatch_sync");
                                                closure()
                                            }
                                        } else {
                                            NSLog("---LoginViewController dispatch_sync else");
                                            // 恐らく実行されない
                                            closure()
                                        }
        })
    }
    
}