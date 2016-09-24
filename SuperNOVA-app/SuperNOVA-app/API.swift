    //
    //  UserAPI.swift
    //  Terrace
    //
    //  Created by y-okada on 2016/09/24.
    //  Copyright © 2016年 SuperNOVA. All rights reserved.
    //
    
    import Foundation
    import UIKit
    
    /// APIクラス<br>
    /// APIリクエストを簡略的に使用することを目的としたクラス<br>
    ///
    final class API {
        
        /// コンストラクタ
        /// 該当機能ではインスタンスの生成が不要となる為、privateで宣言
        private init(){}
        
        private static let debug_log        : Bool              = true
        
//        private static let using_basic      : Bool              = true
        private static let using_basic      : Bool              = false
        /// BASIC認証ユーザ
        private static let basic_user       : String            = "user"
        /// BASIC認証パスワード
        private static let basic_password   : String            = "pass"
        /// ドメインプロトコル
        private static let domain_protocol  : String            = "https://"
        //        private static let domain_protocol  : String            = "http://"
        /// デフォルトドメイン
        private static let domain           : String            = "supernova-hack.com";
        //        private static let domain           : String            = "localhost";
        //POST用URL
        private static let post_domain      : String            = "\(domain_protocol)\(domain)/"
        
        //GET用URL
        private static let get_domain       : String            = using_basic ? "\(domain_protocol)\(basic_user):\(basic_password)@\(domain)/" : "\(domain_protocol)\(domain)/";
        
        
        private static let base64EncodedCredential              = "\(basic_user):\(basic_password)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        private static let basic_auth_word                      = "Basic \(base64EncodedCredential)"
        
        
        
        
        /// boundary
        private static let boundary         : NSString          = NSUUID().UUIDString
        /// boundary data
        private static let boundaryData     : NSData            = "--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!
        /// formContentType
        private static let formDataType     : NSData            = "Content-Disposition: form-data;".dataUsingEncoding(NSUTF8StringEncoding)!
        /// タイムアウト時間(秒)
        private static let timeoutInterval  : NSTimeInterval    = 40
        
        private static var isCached         : Bool              = true
        
        private static let file_max_size    : Int!              = 2097152
        
        
        /// リクエストキャッシュ可否設定<br>
        /// リクエストを行った際にレスポンスをキャッシュするかの可否を設定します。<br>
        /// 当項目を設定することでキャッシュ動作の抑制とキャッシュの削除が行えます。<br>
        /// ※キャッシュの削除はNSURL系統のキャッシュを一括で削除します。
        ///
        /// - parameter cached: キャッシュ可否(trueの場合、キャッシュを実施し、falseの場合キャッシュを削除し、キャッシュを行わないよう抑制する)
        ///
        static func updateCacheStatus(let cached : Bool){
            isCached = cached
            //キャッシュの削除
            if !cached {
                NSURLCache.sharedURLCache().removeAllCachedResponses()
            }
        }
        
        
        /// リクエストメソッド<br>
        /// 各種APIリクエストの元となるリクエストメソッド<br>
        ///
        /// - parameter apiName:    接続先のAPIのURI
        /// - parameter methodName: HTTPメソッド
        /// - parameter params:     リクエストパラメータ(nil許容->パラメータなし)<br>
        ///   URLへのエンコーディングは当メソッドで処理されます。<br>
        ///   例)key1=val1&key2=val2
        /// - parameter sync:       同期設定(true=同期,false=非同期)
        /// - parameter success:    成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void?)
        /// - parameter failed:     失敗時コールバックメソッド(let (Int?,String?) -> Void?)
        ///
        /// -returns:
        ///
        static func request(let apiName :String!,let methodName :APIHTTPMethod!,let params :Dictionary<String,String?>?,let sync : Bool, let success:((Dictionary<String,AnyObject>) -> Void)?, failed:((Int?,String?) -> Void)?) -> Void{
            
            //セッションの作成
            
            let session     : NSURLSession              = NSURLSession.sharedSession()
            var paramWord   : String                    = methodName.rawValue == APIHTTPMethod.GET.rawValue ? "?" : ""
            var request     : NSMutableURLRequest
            
            //各種パラメータの設定
            if params != nil && !params!.isEmpty{
                var isEmpty = true
                //let allowedCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
                //allowedCharacterSet.addCharactersInString("-._~")
                params?.forEach({ key,value in
                    let encKey    = key;//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                    let encValue  = value != nil
                        ? value!//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                        : ""
                    // TODO:ここの部分の記述をもう少し綺麗にかけないか
                    if !isEmpty{
                        paramWord += "&\(encKey)=\(encValue)"
                    }else{
                        paramWord += "\(encKey)=\(encValue)"
                        isEmpty = false
                    }
                })
                
            }
            
            //パラメータの設定
            //GETのみURLに設定
            //その他はBodyに設定
            if methodName.rawValue == APIHTTPMethod.GET.rawValue{
                let urlWord             = get_domain+apiName+paramWord
                let url : NSURL         = NSURL(string: urlWord)!
                request                 = NSMutableURLRequest(URL: url)
                request.HTTPMethod      = methodName.rawValue
                request.timeoutInterval = timeoutInterval
                log("URL:\(url)[GET]")
                //キャッシュ制御
                if !isCached {
                    request.cachePolicy     = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
                }
                
            }else{
                let urlWord             = post_domain+apiName
                let url : NSURL         = NSURL(string: urlWord)!
                request                 = NSMutableURLRequest(URL: url)
                request.HTTPMethod      = methodName.rawValue
                request.HTTPBody        = paramWord.dataUsingEncoding(NSUTF8StringEncoding)
                request.timeoutInterval = timeoutInterval
                log("URL:\(url)[\(methodName.rawValue)]")
                if debug_log && params != nil && !params!.isEmpty{
                    params?.forEach({ key,value in
                        let encKey    = key;//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                        let encValue  = value != nil
                            ? value!//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                            : ""
                        log("param:\(encKey)[\(encValue)]")
                    })
                }
                
                //キャッシュ制御
                if !isCached {
                    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
                }
            }
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            if using_basic && methodName.rawValue != APIHTTPMethod.GET.rawValue {
                request.setValue(basic_auth_word, forHTTPHeaderField: "Authorization")
                log("Auth:\(basic_user):\(basic_password)")
            }
            
            //同期する場合
            if sync {
                var selfData        : NSData?               = nil
                var selfResponse    : NSURLResponse?        = nil
                var selfErr         : NSError?              = nil
                let semaphore       : dispatch_semaphore_t! = dispatch_semaphore_create(0)
                //リクエストの送信
                let task = session.dataTaskWithRequest(request, completionHandler: {
                    //レスポンスの処理
                    (data, response, err) in
                    selfData        = data
                    selfResponse    = response
                    selfErr         = err
                    
                    if debug_log {
                        let res = response as? NSHTTPURLResponse
                        log("Response")
                        log("ID:\(res?.statusCode)")
                        log("DESC:\(res?.debugDescription)")
                    }
                    dispatch_semaphore_signal(semaphore)
                })
                task.resume()
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                if selfErr != nil {
                    failed!(selfErr?.code,selfErr?.description)
                    return
                }
                
                //正常なステータス(200)以外の場合はエラークロージャを呼んで終了する
                if let httpResponse = selfResponse as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 503{
                        failed!(httpResponse.statusCode, httpResponse.description)
                        return
                    }
                }
                //JSONの分解
                var json : Dictionary<String,AnyObject> = Dictionary()
                do {
                    if selfData!.length > 2 {
                        json = try NSJSONSerialization.JSONObjectWithData(selfData!, options: .MutableContainers) as! Dictionary<String,AnyObject>
                        if debug_log {
                            log(NSString(data: selfData!, encoding: NSUTF8StringEncoding) as! String)
                        }
                    }
                } catch {
                    print("failed parse - \(NSString(data:selfData!, encoding:NSUTF8StringEncoding))")
                }
                success!(json)
            }
                //非同期の場合
            else {
                //リクエストの送信
                let task = session.dataTaskWithRequest(request, completionHandler: {
                    //レスポンスの処理
                    (data, response, err) in
                    if debug_log {
                        let res = response as? NSHTTPURLResponse
                        log("Response")
                        log("ID:\(res?.statusCode)")
                        log("DESC:\(res?.debugDescription)")
                    }
                    
                    if err != nil {
                        failed!(err?.code,err?.description)
                        return
                    }
                    
                    //正常なステータス(200)以外の場合はエラークロージャを呼んで終了する
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 503 {
                            failed!(httpResponse.statusCode, httpResponse.description)
                            return
                        }
                    }
                    //JSONの分解
                    var json : Dictionary<String,AnyObject> = Dictionary()
                    do {
                        // FIXME: 空の返却値の対応はこれで良いかを確認
                        if data!.length > 2 {
                            json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! Dictionary<String,AnyObject>
                            if debug_log {
                                log(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String)
                            }
                        }
                    } catch  {
                        print("failed parse - \(NSString(data:data!, encoding:NSUTF8StringEncoding))")
                    }
                    success!(json)
                })
                task.resume()
            }
        }
        
        /// リクエストメソッド<br>
        /// 各種APIリクエストの元となるリクエストメソッド<br>
        ///
        /// - parameter apiName:    接続先のAPIのURI
        /// - parameter methodName: HTTPメソッド
        /// - parameter params:     リクエストパラメータ(nil許容->パラメータなし)
        /// - parameter datas:      リクエストに設定するバイトデータ(nil許容->パラメータなし)<br>
        ///   URLへのエンコーディングは当メソッドで処理されます。<br>
        ///   例)key1=val1&key2=val2
        /// - parameter sync:       同期設定(true=同期,false=非同期)
        /// - parameter success:    成功時コールバックメソッド(let Dictionary<String,AnyObject>) -> Void?)
        /// - parameter failed:     失敗時コールバックメソッド(let (Int?,String?) -> Void?)
        ///
        /// -returns:
        ///
        static func requestWithData(let apiName :String!, let params :Dictionary<String,String?>?,let datas:Array<UploadFile>!,let sync : Bool, let success:((Dictionary<String,AnyObject>) -> Void)?, failed:((Int?,String?) -> Void)?) -> Void{
            
            //        //そもそもバイトデータが存在しない場合は、requestで処理を行う
            //        if datas.isEmpty {
            //            API.request(apiName, methodName: API.HTTPMethod.POST, params: params, success: success, failed: failed)
            //            return
            //        }
            
            let session : NSURLSession              = NSURLSession.sharedSession()
            let data    : NSMutableData             = NSMutableData()
            let urlWord                             = post_domain+apiName
            let url     : NSURL                     = NSURL(string: urlWord)!
            let request : NSMutableURLRequest       = NSMutableURLRequest(URL: url)
            request.HTTPMethod                  = APIHTTPMethod.POST.rawValue
            request.timeoutInterval             = timeoutInterval
            
            
            log("URL:\(url)[POST]")
            
            //各種情報の作成
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if using_basic {
                request.setValue(basic_auth_word, forHTTPHeaderField: "Authorization")
                log("Auth:\(basic_user):\(basic_password)")
            }
            
            //キャッシュ制御
            if !isCached {
                request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
            }
            
            
            //let allowedCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
            //allowedCharacterSet.addCharactersInString("-._~")
            //各種パラメータの設定
            if params != nil && !params!.isEmpty{
                params?.forEach({ key,value in
                    let encKey    = key;//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                    let encValue  = value != nil
                        ? value!//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                        : ""
                    data.appendData(boundaryData)
                    data.appendData(formDataType)
                    data.appendData("name=\"\(encKey)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    data.appendData("\(encValue)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    log("param:\(encKey)[\(encValue)]")
                })
            }
            //NSLog("\r%@",NSString(data: data, encoding: NSUTF8StringEncoding))
            
            //画像データの設定
            datas.forEach({
                uploadData in
                let encName     = uploadData.name;//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                let encFileName = uploadData.fileName;//.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
                data.appendData(boundaryData)
                data.appendData(formDataType)
                data.appendData("name=\"\(encName)\";".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("filename=\"\(encFileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("Content-Type: \(uploadData.contentType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData(uploadData.data)
                data.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            })
            
            //最後にBoundaryをつける
            data.appendData(boundaryData)
            request.HTTPBody    = data
            request.setValue(String(data.length), forHTTPHeaderField: "Content-Length")
            //同期する場合
            if sync {
                var selfData        : NSData?               = nil
                var selfResponse    : NSURLResponse?        = nil
                var selfErr         : NSError?              = nil
                let semaphore       : dispatch_semaphore_t! = dispatch_semaphore_create(0)
                //リクエストの送信
                let task = session.dataTaskWithRequest(request, completionHandler: {
                    //レスポンスの処理
                    (data, response, err) in
                    selfData        = data
                    selfResponse    = response
                    selfErr         = err
                    dispatch_semaphore_signal(semaphore)
                })
                task.resume()
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                if selfErr != nil {
                    failed!(selfErr?.code,selfErr?.description)
                    return
                }
                
                //正常なステータス(200)以外の場合はエラークロージャを呼んで終了する
                if let httpResponse = selfResponse as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 503{
                        failed!(httpResponse.statusCode, httpResponse.description)
                        return
                    }
                }
                //JSONの分解
                var json : Dictionary<String,AnyObject> = Dictionary()
                do {
                    if selfData!.length > 2 {
                        json = try NSJSONSerialization.JSONObjectWithData(selfData!, options: .MutableContainers) as! Dictionary<String,AnyObject>
                        if debug_log {
                            log(NSString(data: selfData!, encoding: NSUTF8StringEncoding) as! String)
                        }
                    }
                } catch {
                    print("failed parse - \(NSString(data:selfData!, encoding:NSUTF8StringEncoding))")
                }
                success!(json)
            }
                //非同期の場合
            else {
                //リクエストの送信
                let task = session.dataTaskWithRequest(request, completionHandler: {
                    //レスポンスの処理
                    (data, response, err) in
                    if debug_log {
                        let res = response as? NSHTTPURLResponse
                        log("Response")
                        log("ID:\(res?.statusCode)")
                        log("DESC:\(res?.debugDescription)")
                    }
                    if err != nil {
                        failed!(err?.code,err?.description)
                        return
                    }
                    
                    //正常なステータス(200)以外の場合はエラークロージャを呼んで終了する
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 503 {
                            failed!(httpResponse.statusCode, httpResponse.description)
                            return
                        }
                    }
                    //JSONの分解
                    var json : Dictionary<String,AnyObject> = Dictionary()
                    do {
                        // FIXME: 空の返却値の対応はこれで良いかを確認
                        if data!.length > 2 {
                            json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! Dictionary<String,AnyObject>
                            if debug_log {
                                log(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String)
                            }
                        }
                    } catch  {
                        print("failed parse - \(NSString(data:data!, encoding:NSUTF8StringEncoding))")
                    }
                    success!(json)
                })
                task.resume()
            }
        }
        
        
        /// 配列型をパラメータに変換<br>
        /// 配列を以下のパターンにてdicに追加<br>
        /// キー名:keyName[0~?] 値:arr.value<br>
        ///
        /// - parameter dic:     パラメータディクショナリ(inout)
        /// - parameter keyName: キープレフィックス
        /// - parameter arr:     値配列
        ///
        /// -returns:
        ///
        static func addToDic(inout dic :Dictionary<String,String?>, let keyName :String!, let arr :Array<String>!)->Void{
            var index = 0;
            arr.forEach({
                value in
                dic.updateValue(value, forKey: ("\(keyName)[\(index)]"))
                index += 1
            })
        }
        
        /// 文字列の文字数の超過チェック<br>
        /// 超過をしていた場合、引数のfailedが呼び出され、その後trueが返却される。<br>
        /// 超過をしていない場合、falseが返却される。<br>
        ///
        /// - parameter value:      確認対象の文字列
        /// - parameter length:     対象の設定可能な最大長
        /// - parameter failed:     失敗時の呼び出しコールバック
        ///
        /// - returns:
        ///
        static func validateStringLengthExceed(let value : String?, let length : Int!, failed:((Int?,String?) -> Void)?) -> Bool{
            
            if value?.characters.count > length {
                failed!(-1, "length over.")
                return true
            }
            return false
        }
        
        /// 画像のファイルサイズの超過チェック<br>
        /// 超過をしていた場合、引数のfailedが呼び出され、その後trueが返却される。<br>
        /// 超過をしていない場合、falseが返却される。<br>
        ///
        /// - parameter value:      確認対象の画像データ
        /// - parameter failed:     失敗時の呼び出しコールバック
        ///
        /// - returns:
        ///
        static func validateDataLengthExceed(let value : NSData!, failed:((Int?,String?) -> Void)?) -> Bool{
            
            if value?.length > file_max_size {
                failed!(-2, "length over.")
                return true
            }
            return false
        }
        
        /// Jpeg判定<br>
        /// 引数のdataのバイトデータがJpegであるかを判断する。<br>
        /// Jpegである場合、true、それ以外の場合はfalseを返却する。<br>
        /// 判定にはJpegのマジックパケットを利用する。<br>
        /// マジックパケット：\0xff\0xd8
        ///
        /// - parameter data: 確認対象のバイトNSData
        ///
        /// - returns:
        ///
        static func isJpeg( let data : NSData! ) -> Bool{
            
            if data.length < 2{
                return false
            }
            
            var buf : Array<Int8>  = Array<Int8>(count: 2, repeatedValue: 0)
            // aBufferにバイナリデータを格納。
            data.getBytes(&buf, length: 2) // &がアドレス演算子みたいに使える。
            return buf[0] == -1 && buf[1] == -40 ? true : false
        }
        
        /// Png判定<br>
        /// 引数のdataのバイトデータがPngであるかを判断する。<br>
        /// Pngである場合、true、それ以外の場合はfalseを返却する。<br>
        /// 判定にはPngのマジックパケットを利用する。<br>
        /// マジックパケット：\0x89PNG\0x0d\0x0a\0x1a\0x0a
        ///
        /// - parameter data: 確認対象のバイトNSData
        ///
        /// - returns:
        ///
        static func isPng( let data : NSData! ) -> Bool{
            
            if data.length < 8{
                return false
            }
            
            var buf : Array<Int8>  = Array<Int8>(count: 8, repeatedValue: 0)
            // aBufferにバイナリデータを格納。
            data.getBytes(&buf, length: 8) // &がアドレス演算子みたいに使える。
            return buf[0] == -119 && buf[1] == 80 && buf[2] == 78 && buf[3] == 71 && buf[4] == 13 && buf[5] == 10 && buf[6] == 26 && buf[7] == 10 ? true : false
        }
        
        /// エラー判定<br>
        /// 引数のparamsがエラー状態であるかを判定する。<br>
        ///
        /// - parameter params: request受信後の正常データ
        ///
        /// - returns: errorCodeが存在するもしくはerrorMessageが存在する場合true、それ以外の場合はfalse
        ///
        static func isError( let params : Dictionary<String,AnyObject>! ) -> Bool{
            return params.indexForKey("errorCode") != nil || params.indexForKey("errorMessage") != nil
        }
        
        
        private static func log(let val : String!){
            if debug_log {
                NSLog("%@",val)
            }
        }
        
        /// 画像ダウンロード<br>
        /// 指定したURLの画像をダウンロードする。<br>
        /// 必要な場合、Basic認証を行う。<br>
        ///
        /// - parameter urlWord: ダウンロード対象となるURL
        ///
        /// - returns: 画像のダウンロードが正常に行えた場合、そのインスタンス、ダウンロードを行えなかった場合 nilを返却
        ///
        static func downloadImage(let urlWord : String!) -> UIImage? {
            
            if urlWord == "" {
                return nil
            }
            
            let url : NSURL! = NSURL(string: urlWord)
            
            if using_basic {
                let session     : NSURLSession              = NSURLSession.sharedSession()
                let request     : NSMutableURLRequest       = NSMutableURLRequest(URL: url)
                let semaphore   : dispatch_semaphore_t!     = dispatch_semaphore_create(0)
                var selfData    : NSData?                   = nil
                //var selfResponse    : NSURLResponse?        = nil
                var selfErr     : NSError?                  = nil
                request.HTTPMethod                          = APIHTTPMethod.GET.rawValue
                request.timeoutInterval                     = timeoutInterval
                request.setValue(basic_auth_word, forHTTPHeaderField: "Authorization")
                
                //キャッシュ制御
                if !isCached {
                    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
                }
                
                let task = session.dataTaskWithRequest(request, completionHandler: {
                    //レスポンスの処理
                    (data, response, err) in
                    selfData = data
                    selfErr  = err
                    dispatch_semaphore_signal(semaphore)
                })
                task.resume()
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                
                if selfErr != nil || selfData == nil {
                    return nil
                }
                return UIImage(data: selfData!)
            }
            else {
                if let data: NSData! = NSData(contentsOfURL: url) {
                    return UIImage(data:data!)
                }
            }
            
            return nil
        }
        
        /// 画像ダウンロード<br>
        /// 指定したURLの画像をダウンロードする。<br>
        /// 必要な場合、Basic認証を行う。<br>
        ///
        /// - parameter urlWord: ダウンロード対象となるURL
        ///
        /// - returns: 画像のダウンロードが正常に行えた場合、そのインスタンス、ダウンロードを行えなかった場合 nilを返却
        ///
        static func downloadASyncData(let urlWord : String!, let downloaded:(NSData?) -> Void) {
            
            if urlWord == "" {
                return
            }
            
            let url : NSURL! = NSURL(string: urlWord)
            
            if using_basic {
                let session     : NSURLSession              = NSURLSession.sharedSession()
                let request     : NSMutableURLRequest       = NSMutableURLRequest(URL: url)
                request.HTTPMethod                          = APIHTTPMethod.GET.rawValue
                request.timeoutInterval                     = timeoutInterval
                request.setValue(basic_auth_word, forHTTPHeaderField: "Authorization")
                
                //キャッシュ制御
                if !isCached {
                    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
                }
                
                let task = session.dataTaskWithRequest(request, completionHandler: {
                    //レスポンスの処理
                    (data, response, err) in
                    downloaded(data)
                })
                task.resume()
            }
            else {
                if let data: NSData! = NSData(contentsOfURL: url) {
                    downloaded(data)
                }
            }
        }
    }
    
