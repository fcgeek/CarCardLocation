//
//  HudUtils.swift
//  rng
//
//  Created by liujianlin on 2017/7/21.
//  Copyright © 2017年 mikazuki. All rights reserved.
//

import UIKit
import MBProgressHUD

class HudUtils {
    static let shared = HudUtils()
    private init() { }
    func show(with description:String, inView view: UIView = UIView.topView()) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        // Set the annular determinate mode to show task progress.
        hud.mode = .text
        hud.label.text = description
        hud.label.numberOfLines = 0
        hud.isUserInteractionEnabled = false
        HudUtils.shared.hideAll(deadline: 2, for: view)
    }
    
    func show(inView view: UIView = UIView.topView()) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideAll(deadline: Double, for view: UIView = UIView.topView()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) { [weak self] in
            self?.hideAll(for: view)
        }
    }
    
    func hideAll(for view: UIView = UIView.topView()) {
        if MBProgressHUD.hide(for: view, animated: true) {
            hideAll(for: view)
        }
    }
}
