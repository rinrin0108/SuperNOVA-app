//
//  AlertUtil.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit

class AlertUtil {
    
    /// OKボタンのみ表示するアラートビューを生成する<br>
    /// OKボタンを押下しても何もイベントは起こさない
    static func alertError(view: UIViewController, title: String, message: String) {
        let alert:UIAlertController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BUTTON_OK", comment: ""),
            style: UIAlertActionStyle.Cancel,
            handler: nil)
        );
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    /// OKボタン、キャンセルボタンを表示するアラートビューを生成する<br>
    /// OKボタン押下時のイベントを設定できる<br>
    /// キャンセルボタンを押下しても何もイベントは起こさない
    static func alertConfirm(view: UIViewController, title: String, message: String, handler: (UIAlertAction) -> Void) {
        let alert:UIAlertController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: UIAlertControllerStyle.Alert);
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BUTTON_OK", comment: ""),
            style: UIAlertActionStyle.Default,
            handler: handler)
        );
        alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_BUTTON_CANCEL", comment: ""),
            style: UIAlertActionStyle.Cancel,
            handler: nil)
        );
        view.presentViewController(alert, animated: true, completion: nil)
    }
}
