//
//  ConversationViewController.swift
//  SuperNOVA-app
//
//  Created by Atsushi Hayashida on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var timer = NSTimer()
    var timerCount = 10    // 秒数
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        startEndButton.setTitle("Start", forState: .Normal)
        timerLabel.text = "\(timerCount / 60) min \(timerCount % 60) sec"
    }
    
    @IBOutlet weak var startEndButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func pushStartEnd(sender: AnyObject) {
        if(startEndButton.titleLabel?.text == "Start"){
            // Startボタン押下
            startEndButton.setTitle("End", forState: .Normal)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ConversationViewController.Counting), userInfo: nil, repeats: true)
            
        } else {
            // Endボタン押下
            timer.invalidate()
            // 画面遷移
            let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "EvaluateView" )
            self.presentViewController( targetViewController, animated: true, completion: nil)
        }
    }
    
    // タイマー処理
    func Counting(){
        timerCount -= 1
        timerLabel.text = "\(timerCount / 60) min \(timerCount % 60) sec"
        if timerCount == 0 {
            timer.invalidate()
            pushStartEnd(startEndButton)
        }
    }
    
}