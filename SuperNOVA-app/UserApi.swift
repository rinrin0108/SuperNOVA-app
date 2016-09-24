//
//  UserApi.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation

class UserAPI {
    
    /// コンストラクタ
    /// 該当機能ではインスタンスの生成が不要となる為、privateで宣言
    private init(){}
    
    /// ユーザ情報登録API<br>
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
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func registUser(let email : String!, let first_name : String!, let last_name : String!, let image : NSData?, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        NSLog("UserApi registUser");
        //バリデーション
        //        if API.validateStringLengthExceed(mailAddress, length: 256, failed: failed){return}
        if image != nil && API.validateDataLengthExceed(image, failed: failed){return}
        //        if API.validateStringLengthExceed(name,        length: 50,  failed: failed){return}
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(email,     forKey: "userid")
        params.updateValue(first_name,            forKey: "firstname")
        params.updateValue(last_name,            forKey: "lastname")
        NSLog(params.debugDescription);

        //データの設定
        var datas : Array<UploadFile> = Array<UploadFile>()
        if image != nil {
            if API.isJpeg(image!){
                NSLog("UserApi isJpeg");
                let data : UploadFile  = UploadFile(fileName: "image", data: image!, contentType: APIContentType.IMAGE_JPG)
                datas.append(data)
            }
            else if API.isPng(image){
                NSLog("UserApi isPng");
                let data : UploadFile  = UploadFile(fileName: "image", data: image!, contentType: APIContentType.IMAGE_PNG)
                datas.append(data)
            }
        }
        NSLog(params.debugDescription);
        NSLog(datas.debugDescription);
        //リクエストの送信
//        API.request("registUser", methodName: APIHTTPMethod.POST,params: params, sync: sync, success: success, failed: failed)
        API.requestWithData("registUser", params: params, datas: datas, sync: sync, success: success, failed: failed)
    }
    
    /// ユーザ情報の取得API<br>
    /// 引数に与えられたユーザIDのユーザのログイン情報を取得する<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    /// <br>
    /// グループ登録済みの場合<br>
    /// ・ ユーザID(userId)           - Integer<br>
    /// ・ メールアドレス(mailaddress) - String<br>
    /// ・ 表示名(name)               - String<br>
    /// ・ 家賃(rent)                 - Integer<br>
    /// ・ 画像URL(imageUrl)          - String<br>
    /// ・ 権限(role)                 - Integer(0:一般、1:管理者)<br>
    /// ・ グループID(groupId)         - Integer<br>
    /// ・ 未払金(amount)             - Integer<br>
    /// <br>
    /// グループ未登録の場合<br>
    /// ・ ユーザID(userId)           - Integer<br>
    /// ・ メールアドレス(mailaddress)  - String<br>
    /// ・ 表示名(name)               - String<br>
    /// ・ 家賃(rent)                - Integer<br>
    /// ・ 画像URL(imageUrl)         - String<br>
    /// ・ 権限(role)                - Integer(0:一般、1:管理者)<br>
    ///
    /// - parameter userId:         ユーザID(let Int!)
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func find(let userId : Int!, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(String(userId), forKey: "userId")
        
        //リクエストの送信
        API.request("api/user/find", methodName: APIHTTPMethod.POST, params: params, sync: sync, success: success, failed: failed)
    }
    
    /// ユーザ情報の更新API<br>
    /// 該当ユーザのユーザ情報を更新する<br>
    /// 引数がnilの引数については更新の対象としない。<br>
    /// <br>
    /// successのクロージャに対して、以下のパラメータを含めコールバックする。<br>
    /// ・ ユーザID(userId) - Integer<br>
    ///
    /// - parameter userId:         ユーザID(let Int!)
    /// - parameter mailAddress:    メールアドレス(let String?)
    /// - parameter name:           表示名(let String?)
    /// - parameter rent:           家賃(let Int?)
    /// - parameter image:          画像(let NSData?)<br>JpegもしくはPngのみ設定可能。<br>
    ///                             それ以外のファイルだった場合は、未設定という扱いとする。<br>
    ///                             ファイルの判定には、isJpeg( let data : NSData! ) -> Bool、<br>
    ///                             isPng( let data : NSData! ) -> Boolを利用している。
    /// - parameter sync:           同期設定(true=同期,false=非同期)(let Bool!)
    /// - parameter success:        成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void!)
    /// - parameter failed:         失敗時コールバックメソッド(let (Int?,String?) -> Void?)
    ///
    static func update(let userId : Int!, let mailAddress : String?, let name : String?, let rent:Int?, let image : NSData?, let sync : Bool!, let success:((Dictionary<String,AnyObject>) -> Void)!, failed:((Int?,String?) -> Void)?){
        
        //文字数チェック
        //        if mailAddress != nil && API.validateStringLengthExceed(mailAddress, length: 256, failed: failed){return}
        if image != nil && API.validateDataLengthExceed(image, failed: failed){return}
        //        if name        != nil && API.validateStringLengthExceed(name,        length: 50,  failed: failed){return}
        
        //パラメータの設定
        var params : Dictionary<String,String?>= Dictionary<String,String?>()
        params.updateValue(String(userId),  forKey: "userId")
        if mailAddress  != nil { params.updateValue(mailAddress!,    forKey: "mailaddress") }
        if name         != nil { params.updateValue(name!,           forKey: "name")        }
        if rent         != nil { params.updateValue(String(rent!),   forKey: "rent")        }
        
        //データの設定
        var datas : Array<UploadFile> = Array<UploadFile>()
        if image != nil {
            if API.isJpeg(image!){
                let data : UploadFile  = UploadFile(fileName: "image", data: image!, contentType: APIContentType.IMAGE_JPG)
                datas.append(data)
            }
            else if API.isPng(image){
                let data : UploadFile  = UploadFile(fileName: "image", data: image!, contentType: APIContentType.IMAGE_PNG)
                datas.append(data)
            }
        }
        //リクエストの送信
        API.requestWithData("api/user/update", params: params, datas: datas, sync: sync, success: success, failed: failed)
    }
    
}


