//
//  CompatibleView.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/16.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit

typealias CompatibleView = UIView

extension CompatibleView {
    var comp: CompatibleViewDSL {
        return CompatibleViewDSL.init(view: self)
    }
}


struct CompatibleViewDSL {
    
    var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    public var target: AnyObject? {
        return self.view
    }
    
    internal let view: CompatibleView
    
    internal init(view: CompatibleView) {
        self.view = view
        
    }
}
