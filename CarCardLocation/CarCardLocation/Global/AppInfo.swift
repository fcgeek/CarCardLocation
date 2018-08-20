//
//  AppInfo.swift
//  MoeBuy
//
//  Created by liujianlin on 16/8/3.
//  Copyright © 2016年 xdream. All rights reserved.
//

import UIKit

struct AppInfo {
    static var name: String {
        get {
            return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
    static var version: String {
        get {
            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        }
    }
    static var buildVersion: String {
        get {
            return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        }
    }
}
