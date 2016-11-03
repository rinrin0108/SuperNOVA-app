//
//  CallViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    override
    func viewDidLoad() {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        shopName.text = appDelegate._shoptitle
    }
    
    @IBOutlet weak var shopName: UILabel!
    @IBAction func change30m(sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate._time = "30"
    }
    
    @IBAction func change60m(sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate._time = "60"
    }
    
    @IBAction func call(sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        if(appDelegate._time == ""){
            appDelegate._time = "30"
        }
        
        // 画面遷移
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toWaitingMapView")
        
    }
}