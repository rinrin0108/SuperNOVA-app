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

    override
    func viewDidLoad() {
        super.viewDidLoad()
        
                //Facebookがログイン済みの場合その情報を反映させる。
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                        parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
                    graphRequest.startWithCompletionHandler({
                        connection, result, error in
        
                        if error != nil
                        {
                            // エラー処理
                            print("Error: \(error)")
                        }
                        else
                        {
                            // プロフィール情報をディクショナリに入れる
                            let userProfile : NSDictionary! = result as! NSDictionary
        
                            // プロフィール画像の取得
                            let profileImageURL : String = userProfile.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
                            
                            print(userProfile.objectForKey("name") as? String);
                            print(userProfile.objectForKey("email") as? String);
        
//                            if profileImageURL != "" {
//                                let profileImage : UIImage? = API.downloadImage(profileImageURL)
//                                self.profile.image = profileImage
//                                self.selectImage = profileImage
//                                self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
//                                self.profile.clipsToBounds = true
//                            }
        
                            //ユーザIDとメールアドレスを設定
//                            self.userId.text = userProfile.objectForKey("name") as? String
//                            self.email.text  = userProfile.objectForKey("email") as? String
                        }
                    })
                }
        
    }
}