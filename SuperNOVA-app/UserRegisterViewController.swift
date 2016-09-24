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
    private var selectImage: UIImage?


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
                            
                            print(userProfile.objectForKey("id") as? String);
                            print(userProfile.objectForKey("name") as? String);
                            print(userProfile.objectForKey("first_name") as? String);
                            print(userProfile.objectForKey("last_name") as? String);
                            print(userProfile.objectForKey("picture") as? String);
                            print(userProfile.objectForKey("email") as? String);
        
                            if profileImageURL != "" {
                                let profileImage : UIImage? = API.downloadImage(profileImageURL)
                                self.profile.image = profileImage
                                self.selectImage = profileImage
                                self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
                                self.profile.clipsToBounds = true
                            }
        
                            //ユーザID,メールアドレス,氏,名を設定
                            self.first_name.text = userProfile.objectForKey("first_name") as? String
                            self.last_name.text = userProfile.objectForKey("last_name") as? String
                            self.email.text  = userProfile.objectForKey("email") as? String
                        }
                    })
                }
        
    }
}