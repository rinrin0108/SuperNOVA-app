//
//  AccountInfo.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation


/// アカウント情報クラス<br>
/// アカウントの情報をアプリケーション内で共通で使用する為のクラス<br>
///
final class AccountInfo {
    
    private let store               : NSUserDefaults    = NSUserDefaults.standardUserDefaults()
    ///キー一覧
    /// メールアドレス
    private let mailAddressKey      : String!           = "userid"
    /// プロフィール画像
    private let imageKey            : String!           = "image"

    /// Full Name
    private let fullnameKey      : String!           = "fullname"
    
    
    /// メールアドレス
    private var mailAddressValue : String!
    
    /// プロフィール画像URL
    private var imageValue : String!

    /// Full Name
    private var fullnameValue      : String!

    ///シングルトンインスタンス
    private static let info : AccountInfo = AccountInfo()
    static func get() -> AccountInfo{ return info }
    
    /// コンストラクタ
    /// 該当機能ではインスタンスの生成を外部で行わない為、privateとする。
    private init(){
        
        NSLog("AccountInfo init");
        // キーがidの値をとります。
        let mailAddressValue    : String?   = store.stringForKey(mailAddressKey)
        NSLog(mailAddressValue!);
        let imageValue          : String?   = store.stringForKey(imageKey)
        NSLog(imageValue!);
        let fullnameValue    : String?   = store.stringForKey(fullnameKey)
        NSLog(fullnameValue!);
        
        //値の設定
        self.mailAddressValue   = mailAddressValue  != nil ? mailAddressValue : ""
        NSLog(self.mailAddress);
        self.imageValue         = imageValue
        NSLog(self.imageValue);
        self.fullnameValue   = fullnameValue
        NSLog(self.fullnameValue);
    }
    
    
    var mailAddress : String!{
        get {
            return mailAddressValue
        }
        set(mailAddressValue) {
            self.mailAddressValue = mailAddressValue
            store.setObject(mailAddressValue, forKey: mailAddressKey)
            store.synchronize()
        }
    }
    
    var image : String!{
        get {
            return imageValue
        }
        set(imageValue) {
            self.imageValue = imageValue
            store.setObject(imageValue, forKey: imageKey)
            store.synchronize()
        }
        
    }
    
    var fullname : String!{
        get {
            return fullnameValue
        }
        set(fullname) {
            self.fullnameValue = fullname
            store.setObject(fullnameValue, forKey: fullnameKey)
            store.synchronize()
        }
    }
    
}
