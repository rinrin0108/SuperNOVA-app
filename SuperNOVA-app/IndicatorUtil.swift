//
//  IndicatorUtil.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit
private var key = 0
struct Indicator {
    
    
    
    static var myActivityIndicator: UIActivityIndicatorView!
    
    static func set(v:UIViewController){
        self.myActivityIndicator = UIActivityIndicatorView()
        self.myActivityIndicator.frame = CGRectMake(0, 0, 50, 50)
        self.myActivityIndicator.center = v.view.center
        self.myActivityIndicator.hidesWhenStopped = false
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.myActivityIndicator.backgroundColor = UIColor.grayColor();
        self.myActivityIndicator.layer.masksToBounds = true
        self.myActivityIndicator.layer.cornerRadius = 5.0;
        self.myActivityIndicator.layer.opacity = 0.8;
        v.view.addSubview(self.myActivityIndicator);
        
        self.dismiss();
    }
    
    static func show(){
        myActivityIndicator.startAnimating();
        myActivityIndicator.hidden = false;
    }
    static func dismiss(){
        myActivityIndicator.stopAnimating();
        myActivityIndicator.hidden = true;
    }
    
    static func windowSet(){
        NSLog("IndicatorUtil windowSet");
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Indicator", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()! as UIViewController
        window.windowLevel = UIWindowLevelNormal + 5
        
        window.makeKeyAndVisible()
        objc_setAssociatedObject(UIApplication.sharedApplication(), &key, window, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    static func windowClose(){
        
        if objc_getAssociatedObject(UIApplication.sharedApplication(), &key) != nil {
            let window :UIWindow = objc_getAssociatedObject(UIApplication.sharedApplication(), &key) as! UIWindow
            window.rootViewController?.view.removeFromSuperview()
            window.rootViewController = nil
            objc_setAssociatedObject(UIApplication.sharedApplication(), &key, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let nextWindow :UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
            nextWindow.makeKeyAndVisible()
        }
    }
}
