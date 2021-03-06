//
//  UserRegisterViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserRegisterViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var first_name: UILabel!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var last_name: UILabel!
    private var profileImageURL :String!
    private var selectImage: UIImage?
    private var isLoaded :Bool = false
    
    
    @IBAction func changeJapanese(sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate._lang = "Japanese"
        appDelegate._native = "English"
    }

    @IBAction func changeEnglish(sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate._lang = "English"
        appDelegate._native = "Japanese"
    }
    
    
    @IBAction func registUser(sender: UIButton) {
        NSLog("---UserRegisterViewController registUser");
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        /**
         *  画像ではなく画像URLを使用
        var data : NSData? = nil
        // プロファイル画像が選択されていた場合
        if(selectImage != nil){
            NSLog("---UserRegisterViewController selectImage");
            // PNG形式の画像フォーマットとしてNSDataに変換
            if let jpg = UIImageJPEGRepresentation(profile.image!, 0.2) {
                data = jpg
                NSLog("---UserRegisterViewController jpg");
            }else if let png = UIImagePNGRepresentation(profile.image!) {
                data = png
                NSLog("---UserRegisterViewController png");
            }
        } else {
            data = UIImagePNGRepresentation(UIImage(named: "user_no_image")!)
            NSLog("---UserRegisterViewController user_no_image");
        }
        */
        
        /**
         * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
        Indicator.windowSet()
        */
        
        if(appDelegate._lang == ""){
            appDelegate._lang      = "Japanese";
            appDelegate._native      = "English";
        }
        
        // ユーザ登録API呼び出し
        UserAPI.registUser(email.text, first_name: first_name.text, last_name: last_name.text , lang: appDelegate._lang , native: appDelegate._native, profileImageURL: profileImageURL ,sync: true,
                        success:{
                        values in let closure = {
                            NSLog("---UserRegisterViewController UserAPI.registUser success");
                            // 通信は成功したが、エラーが返ってきた場合
                            if(API.isError(values)){
                                NSLog("---UserRegisterViewController UserAPI.registUser isError");
                                /**
                                 * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                                Indicator.windowClose()
                                */
                                AlertUtil.alertError(self, title: NSLocalizedString("ALERT_TITLE_ERROR", comment: ""),
                                    message: values["errorMessage"] as! String)
                                return
                            }
                            
                            // API返却値と、画面入力値を端末に保存
                            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
                            appDelegate._userid    = self.email.text
                            appDelegate._image     = self.profileImageURL
                            appDelegate._fullname  = self.first_name.text! + self.last_name.text!
                            //FIXME
                            if(appDelegate._lang == ""){
                                appDelegate._lang      = "Japanese";
                                appDelegate._native      = "English";
                            }
                            
                            /**
                            * ストーリーボードをまたぐ時に値を渡すためのもの（Indicatorストーリーボードを作成する必要あり）
                            Indicator.windowClose()
                            */
                            
                            // MapViewに画面遷移
                            ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toMapView")
                        }
                        // 通知の監視
                        if(!NSThread.isMainThread()){
                            NSLog("---UserRegisterViewController !NSThread.isMainThread() in success");
                            dispatch_sync(dispatch_get_main_queue()) {
                                NSLog("---UserRegisterViewController dispatch_sync");
                                closure()
                            }
                        } else {
                            NSLog("---UserRegisterViewController dispatch_sync else");
                            // 恐らく実行されない
                            closure()
                        }
                        
            },
                       failed: {
                        id, message in let closure = {
                            NSLog("---UserRegisterViewController UserAPI.registUser failed");
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
                            NSLog("---UserRegisterViewController !NSThread.isMainThread() in failed");
                            dispatch_sync(dispatch_get_main_queue()) {
                                NSLog("---UserRegisterViewController dispatch_sync");
                                closure()
                            }
                        } else {
                            NSLog("---UserRegisterViewController dispatch_sync else");
                            //恐らく実行されない
                            closure()
                        }
            }
        )
        
        
    }
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---UserRegisterViewController viewDidLoad");
                //Facebookがログイン済みの場合その情報を反映させる。
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    NSLog("---UserRegisterViewController FBSDKAccessToken.currentAccessToken()");
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                        parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
                    graphRequest.startWithCompletionHandler({
                        connection, result, error in
        
                        if error != nil
                        {
                            // エラー処理
                            NSLog("Error: \(error)")
                        }
                        else
                        {
                            NSLog("---UserRegisterViewController graphRequest.startWithCompletionHandler success");
                            // プロフィール情報をディクショナリに入れる
                            let userProfile : NSDictionary! = result as! NSDictionary
        
                            // プロフィール画像の取得
                            let profileImageURL : String = userProfile.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
                            
                            NSLog((userProfile.objectForKey("id") as? String)!);
                            NSLog((userProfile.objectForKey("name") as? String)!);
                            NSLog((userProfile.objectForKey("first_name") as? String)!);
                            NSLog((userProfile.objectForKey("last_name") as? String)!);
                            NSLog(profileImageURL);
                            NSLog((userProfile.objectForKey("email") as? String)!);
        
                            if profileImageURL != "" {
                                NSLog("---UserRegisterViewController profileImageURL is not null");
                                let profileImage : UIImage? = API.downloadImage(profileImageURL)
                                self.profile.image = profileImage
                                self.selectImage = profileImage
                                self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
                                self.profile.clipsToBounds = true
                            }
        
                            //ユーザID,メールアドレス,氏,名を設定
                            self.first_name.text = userProfile.objectForKey("first_name") as? String
                            NSLog("self.first_name.text!");
                            NSLog(self.first_name.text!);
                            self.last_name.text = userProfile.objectForKey("last_name") as? String
                            NSLog("self.last_name.text!");
                            NSLog(self.last_name.text!);
                            self.email.text  = userProfile.objectForKey("email") as? String
                            NSLog("self.email.text!");
                            NSLog(self.email.text!);
                            self.profileImageURL = profileImageURL
                            NSLog("self.profileImageURL");
                            NSLog(self.profileImageURL);
                        }
                    })
                }
        NSLog("isLoaded");
        isLoaded = true
    }
    
    private func encode(url:String) -> (String){
        return url.stringByReplacingOccurrencesOfString("&", withString: "%%%");
    }
    
    override func viewDidAppear(animated: Bool) {
        if isLoaded{
            for subview in self.view.subviews{
                subview.hidden = false
            }
//            ViewShowAnimation.showAnimation(self);
            isLoaded = false
        }
    }
    
}