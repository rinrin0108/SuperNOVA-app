//
//  MergerApi.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation

class MergerAPI {
    
    /// 教師リクエストAPI<br>
    /// 教師を探す<br>
    /// 引数がnilの引数については更新の対象としない。<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter userId:         ユーザID(let String!)
    /// - parameter lat:            lat(let String!)
    /// - parameter lng:            lat(let String!)
    /// - parameter lang:           lang(let String!)
    /// - parameter place:          place(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func requestTeacher(let userId : String!, let lat : String?, let lng : String?, let lang : String?, let place : String?,let time :String?, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(userId,  forKey: "userid")
        params.updateValue(lat!,    forKey: "lat")
        params.updateValue(lng!,    forKey: "lng")
        params.updateValue(lang!,    forKey: "lang")
        params.updateValue(place!,    forKey: "place")
        params.updateValue(time!,    forKey: "time")
        
        //リクエストの送信
        API.request("requestTeacher", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    /// リクエスト状況を取得API<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter _id:            _id(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func getRequestStatus(let _id : String!,let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(_id,  forKey: "_id")
        
        //リクエストの送信
        API.request("getRequestStatus", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    /// 教師からの承諾レスポンスAPI（マッチング成立）<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter userId:         ユーザID(let String!)
    /// - parameter _id:            _id(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func responseTeacher(let userid : String!,let _id : String!,let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(userid,  forKey: "userid")
        params.updateValue(_id,  forKey: "_id")
        
        //リクエストの送信
        API.request("responseTeacher", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }

    
    /// マッチングキャンセルAPI<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter userId:         ユーザID(let String!)
    /// - parameter _id:            _id(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func cancelPitching(let userid : String!,let _id : String!,let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(userid,  forKey: "userid")
        params.updateValue(_id,  forKey: "_id")
        
        //リクエストの送信
        API.request("cancelPitching", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }

    
    /// マッチングキャンセルAPI<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter _id:            _id(let String!)
    /// - parameter arrive:         arrive(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func updateArrive(let _id : String!,let arrive : String!, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(_id,  forKey: "_id")
        params.updateValue(arrive,  forKey: "arrive")
        
        //リクエストの送信
        API.request("updateArrive", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    /// マッチングキャンセルAPI<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter _id:            _id(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func finishPitching(let _id : String!, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(_id,  forKey: "_id")
        
        //リクエストの送信
        API.request("finishPitching", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
    
    /// ピッチングの到着時間を更新API<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    ///
    /// - parameter _id:            _id(let String!)
    /// - parameter starttime:      starttime(let String!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func updatePitchStarttime(let _id : String!,let starttime : String!, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(_id,  forKey: "_id")
        params.updateValue(starttime,  forKey: "starttime")
        
        //リクエストの送信
        API.request("finishPitching", methodName: APIHTTPMethod.GET, params: params, sync: sync, success: success, failed: failed)
    }
    
}
