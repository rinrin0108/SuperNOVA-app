//
//  ViewShowAnimation.swift
//  Terrace
//
//  Created by 朝日田 卓哉 on 2016/06/24.
//  Copyright © 2016年 山口 竜也. All rights reserved.
//

import UIKit
import QuartzCore

class  ViewShowAnimation :NSObject{
    
    
    static func showAnimation(vc :UIViewController){
        
        let rect = vc.view.frame;
        for subview in vc.view.subviews{
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y - rect.height, subview.frame.width, subview.frame.height);
        }
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in vc.view.subviews{
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + rect.height, subview.frame.width, subview.frame.height);
            }
        }) { (Bool) -> Void in
            
        }
    }
    
    //要素にブラーをかけるタイプ
    func changeAnimation(fromVC :UIViewController, toVC :UIViewController){
        
        for subview in fromVC.view.subviews{
            subview.layer.shouldRasterize = true;
            subview.layer.rasterizationScale = 1.0;
            subview.layer.minificationFilter = kCAFilterTrilinear;
        }
        
        let animation = CABasicAnimation(keyPath: "rasterizationScale");
        animation.fromValue = 1.0;
        animation.toValue = 0.01;
        animation.duration = 0.3;
        animation.removedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity");
        alphaAnimation.fromValue = 1.0;
        alphaAnimation.toValue = 0.0;
        alphaAnimation.duration = 0.3;
        alphaAnimation.removedOnCompletion = false;
        
        for subview in fromVC.view.subviews{
            subview.layer.addAnimation(animation, forKey: "rasterizationScale");
            subview.layer.addAnimation(alphaAnimation, forKey: "opacity");
            subview.layer.minificationFilter = kCAFilterTrilinear;
        }
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            fromVC.presentViewController(toVC, animated: true, completion: nil)
        })
    }
    
    //全体にブラーをかけるタイプ
    static func changeView(fromVC :UIViewController, toVC :UIViewController){
        let blurEffect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView :UIVisualEffectView = UIVisualEffectView(effect: blurEffect);
        blurView.frame = fromVC.view.frame;
        fromVC.view.addSubview(blurView);
        
        blurView.alpha = 0.0;
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in fromVC.view.subviews {
                subview.alpha = 0.0;
            }
            blurView.alpha = 0.3;
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                blurView.alpha = 0.0;
            }) { (Bool) -> Void in
                fromVC.presentViewController(toVC, animated: false, completion: nil)
                //                        for subview in fromVC.view.subviews {
                //                            subview.alpha = 1.0;
                //                        }
                //                        blurView.removeFromSuperview();
            }
        }
    }
    
    static func changeViewWithIdentifer(fromVC :UIViewController, toVC :String){
        let blurEffect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView :UIVisualEffectView = UIVisualEffectView(effect: blurEffect);
        blurView.frame = fromVC.view.frame;
        fromVC.view.addSubview(blurView);
        
        blurView.alpha = 0.0;
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in fromVC.view.subviews {
                subview.alpha = 0.0;
            }
            blurView.alpha = 0.3;
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                blurView.alpha = 0.0;
            }) { (Bool) -> Void in
                fromVC.performSegueWithIdentifier(toVC,sender: nil)
                for subview in fromVC.view.subviews {
                    subview.alpha = 1.0;
                }
                blurView.removeFromSuperview();
            }
        }
    }
    
    static func changeViewWithIdentiferNotRemove(fromVC :UIViewController, toVC :String){
        let blurEffect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView :UIVisualEffectView = UIVisualEffectView(effect: blurEffect);
        blurView.frame = fromVC.view.frame;
        fromVC.view.addSubview(blurView);
        
        blurView.alpha = 0.0;
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in fromVC.view.subviews {
                subview.alpha = 0.0;
            }
            blurView.alpha = 0.3;
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                blurView.alpha = 0.0;
            }) { (Bool) -> Void in
                fromVC.performSegueWithIdentifier(toVC,sender: nil)
                //                        for subview in fromVC.view.subviews {
                //                            subview.alpha = 1.0;
                //                        }
                blurView.removeFromSuperview();
            }
        }
    }
    
    static func changeViewWithIdentiferFromHome(homeView:UIViewController, toVC:String){
        let blurEffect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView :UIVisualEffectView = UIVisualEffectView(effect: blurEffect);
        blurView.frame = homeView.view.frame;
        homeView.view.addSubview(blurView);
        
        blurView.alpha = 0.0;
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in homeView.view.subviews {
                subview.alpha = 0.0;
            }
            blurView.alpha = 0.3;
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                blurView.alpha = 0.0;
            }) { (Bool) -> Void in
                UIView.setAnimationsEnabled(false)
                homeView.performSegueWithIdentifier(toVC,sender: nil)
                UIView.setAnimationsEnabled(true)
                for subview in homeView.view.subviews {
                    subview.alpha = 1.0;
                }
                homeView.view.frame = CGRectMake(0, -homeView.view.frame.height, homeView.view.frame.width, homeView.view.frame.height);
                blurView.removeFromSuperview();
            }
        }
    }
    
    static func returnView(vc: UIViewController, navi :UINavigationController){
        let blurEffect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView :UIVisualEffectView = UIVisualEffectView(effect: blurEffect);
        blurView.frame = vc.view.frame;
        vc.view.addSubview(blurView);
        
        blurView.alpha = 0.0;
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in vc.view.subviews {
                subview.alpha = 0.0;
            }
            blurView.alpha = 0.3;
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                blurView.alpha = 0.0;
            }) { (Bool) -> Void in
                navi.popViewControllerAnimated(false);
            }
        }
    }
    
    static func returnViewModal(vc :UIViewController){
        let blurEffect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView :UIVisualEffectView = UIVisualEffectView(effect: blurEffect);
        blurView.frame = vc.view.frame;
        vc.view.addSubview(blurView);
        
        blurView.alpha = 0.0;
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for subview in vc.view.subviews {
                subview.alpha = 0.0;
            }
            blurView.alpha = 0.3;
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                blurView.alpha = 0.0;
            }) { (Bool) -> Void in
                vc.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}
