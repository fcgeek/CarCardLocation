//
//  UIView+CIExtension.swift
//  CommerceInteraction
//
//  Created by liujianlin on 16/4/15.
//  Copyright © 2016年 ocm. All rights reserved.
//
import UIKit
import MBProgressHUD

extension UIView {
    
    func getCurrentViewController() -> UIViewController! {
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            return topViewController(topController)
        }
        return nil
    }
    
    fileprivate func topViewController(_ vc:UIViewController) -> UIViewController {
        if let nav = vc as? UINavigationController {
            return topViewController(nav.visibleViewController!)
        }
        if let tab = vc as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = vc.presentedViewController {
            return topViewController(presented)
        }
        return vc
        
    }
    
    static func topView() -> UIView {
        return UIApplication.shared.keyWindow!
    }
    
    func addTopLineWithColor(_ color: UIColor, insets: UIEdgeInsets=UIEdgeInsets.zero) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.edges.equalTo(self).inset(insets).priority(600)
            make.height.equalTo(1)
        }
        return line
    }    
    
    func addBottomLineWithColor(_ color: UIColor, insets: UIEdgeInsets=UIEdgeInsets.zero) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.edges.equalTo(self).inset(insets).priority(600)
            make.height.equalTo(1)
        }
        return line
    }
    
    func show(with description:String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .text
        hud.label.text = description
        hud.label.numberOfLines = 0
        hud.hide(animated: true, afterDelay: 2)
    }
}
