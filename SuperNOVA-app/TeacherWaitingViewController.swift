//
//  TeacherWaitingViewController.swift
//  SuperNOVA-app
//
//  Created by t-kurasawa on 2016/09/25.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation
import UIKit

class TeacherWaitingMapViewController: UIViewController {
    @IBAction func checkin(sender: UIButton) {
        ViewShowAnimation.changeViewWithIdentiferFromHome(self, toVC: "toEncounterView")
    }
    
    
}