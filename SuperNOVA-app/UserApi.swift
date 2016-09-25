//
//  UserApi.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation

class UserAPI {
    
    /// コンストラクタ.
    /// 該当機能ではインスタンスの生成が不要となる為、privateで宣言
    private init(){}
    
    /// ユーザ登録API<br>
    /// 新規のユーザの登録を行う<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    /// - メールアドレス(let String!)
    /// - 氏(let String!)
    /// - 名(let String!)
    /// - プロフィール画像:          画像(let NSData?)<br>JpegもしくはPngのみ設定可能。<br>
    ///
    /// - parameter email:    メールアドレス(let String!)
    /// - parameter firstname:           表示名(let String!)
    /// - parameter lastname:           表示名(let String!)
    /// - parameter image:          画像(let NSData?)<br>JpegもしくはPngのみ設定可能。<br>
    ///                             それ以外のファイルだった場合は、未設定という扱いとする。<br>
    ///                             ファイルの判定には、isJpeg( let data : NSData! ) -> Bool、<br>
    ///                             isPng( let data : NSData! ) -> Boolを利用している。
    /// - parameter profileImageURL:           画像URL(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func registUser(let email : String!, let first_name : String!, let last_name : String!, let lang:String!, let native:String! ,let profileImageURL:String!, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        NSLog("UserApi registUser");
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(email,     forKey: "userid")
        params.updateValue(first_name,            forKey: "firstname")
        params.updateValue(last_name,            forKey: "lastname")
        params.updateValue(profileImageURL, forKey: "image")
        params.updateValue(lang, forKey: "lang")
        params.updateValue(native, forKey: "native")
        NSLog(params.debugDescription);

        // リクエストの送信
        API.request("registUser", methodName: APIHTTPMethod.POST,params: params, sync: sync, success: success, failed: failed)
    }
    
    /// ユーザ情報取得API<br>
    /// 引数に与えられたユーザID(メールアドレス)のユーザのログイン情報を取得する<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    /// <br>
    ///
    /// - parameter userId:         ユーザID(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func getUser(let userId : String!, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(userId, forKey: "userid")
        
        //リクエストの送信
        API.request("getUser", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    
    /// ユーザ位置情報更新API<br>
    /// 該当ユーザのユーザ情報を更新する<br>
    /// 引数がnilの引数については更新の対象としない。<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    /// ・ ユーザID(userId) - String<br>
    ///
    /// - parameter userId:         ユーザID(let String!)
    /// - parameter lat:            lat(let String!)
    /// - parameter lng:            lat(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func updateUserLocation(let userId : String!, let lat : String?, let lng : String?, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(userId,  forKey: "userid")
        params.updateValue(lat!,    forKey: "lat")
        params.updateValue(lng!,    forKey: "lng")
        
        //リクエストの送信
        API.request("updateUserLocation", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    /// ユーザ評価更新API<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter userId:         ユーザID(let String!)
    /// - parameter rate:            rate(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func updateUserRate(let userId : String!, let rate : String?, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(userId,  forKey: "userid")
        params.updateValue(rate!,    forKey: "rate")
        
        //リクエストの送信
        API.request("updateUserRate", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    
}


