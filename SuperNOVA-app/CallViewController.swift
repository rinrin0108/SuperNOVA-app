//
//  CallViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    @IBAction func call(sender: UIButton) {
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toConversationView")
    }
}