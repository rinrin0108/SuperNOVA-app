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
    private let mailAddressKey      : String!           = "mailAddress"
    /// プロフィール画像
    private let imageKey            : String!           = "imageKey"

    /// First Name
    private let first_name_key      : String!           = "first_name"
    
    /// Last Name
    private let last_name_key      : String!           = "last_name"
    
    
    /// メールアドレス
    private var mailAddressValue : String!
    
    /// プロフィール画像
    private var imageValue : NSData?

    /// First Name
    private var first_name_value      : String!

    /// First Name
    private var last_name_value      : String!
    
    
    
    ///シングルトンインスタンス
    private static let info : AccountInfo = AccountInfo()
    static func get() -> AccountInfo{ return info }
    
    /// コンストラクタ
    /// 該当機能ではインスタンスの生成を外部で行わない為、privateとする。
    private init(){
        
        // キーがidの値をとります。
        let mailAddressValue    : String?   = store.stringForKey(mailAddressKey)
        let imageValue          : NSData?   = store.dataForKey(imageKey)
        let first_name_value    : String?   = store.stringForKey(first_name)
        let last_name_value    : String?   = store.stringForKey(last_name)
        
        
        //値の設定
        self.mailAddressValue   = mailAddressValue  != nil ? mailAddressValue : ""
        self.imageValue         = imageValue
        self.first_name_value   = first_name_value
        self.last_name_value    = last_name_value
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
    
    var image : NSData?{
        get {
            return imageValue
        }
        set(imageValue) {
            self.imageValue = imageValue
            store.setObject(imageValue, forKey: imageKey)
            store.synchronize()
        }
        
    }
    
    var first_name : String!{
        get {
            return first_name_value
        }
        set(first_name) {
            self.first_name_value = first_name
            store.setObject(first_name_value, forKey: first_name_key)
            store.synchronize()
        }
    }
    
    var last_name : String!{
        get {
            return last_name_value
        }
        set(last_name) {
            self.last_name_value = last_name
            store.setObject(last_name_value, forKey: last_name_key)
            store.synchronize()
        }
    }
    
    
}
