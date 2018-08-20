//
//  CIDefineConstant.swift
//  CommerceInteraction
//
//  Created by liujianlin on 16/4/13.
//  Copyright © 2016年 ocm. All rights reserved.
//
import Foundation
import UIKit

let appScheme = "PinXiaoTu"

//MARK: - SDK Key
let wechatAppid = "wx501b1e888c581cef"
let wechatSecret = "ad635c05193600a7bec561293d0a54dc"

//MARK: - Notification
let loginSuccessNotificationName = NSNotification.Name(rawValue: "LoginSuccessNotification")
let logoutSuccessNotificationName = NSNotification.Name(rawValue: "LogoutSuccessNotification")
let needLoginNotificationName = NSNotification.Name(rawValue: "needLoginNotificationName")
let updateAppNotificationName = NSNotification.Name(rawValue: "updateAppNotificationName")
let alipayCallBackNotificationName = NSNotification.Name(rawValue: "alipayCallBackNotificationName")
let searchHistoryChangeNotificationName = NSNotification.Name(rawValue: "searchHistoryChangeNotificationName")
let kWechatBackNotification=Notification.Name("kWechatBackNotification")
let externalOpenNotification=Notification.Name("extenalOpenNotification")
let recommendListOnTopNotification=Notification.Name("recommendListOnTopNotification")
let homeFixRecommendNotification=Notification.Name("homeFixRecommendNotification")

//MARK: - Constant
let ScreenWidth=UIScreen.main.bounds.width
let ScreenHeight=UIScreen.main.bounds.height
let iPhone5Height:CGFloat=568
let iPhone6Height:CGFloat=667
let iPhone6Width:CGFloat=375
let defaultMargin:CGFloat=16
let defaultTableViewSctionHeight: CGFloat = 24
let statusHeight: CGFloat = UIApplication.shared.statusBarFrame.height
var bottomPadding: CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

//滑动方向
enum ScrollDirection: String {
    case Up="ScrollDirectionUp", Down="ScrollDirectionDown"
}

//MARK: - 给extension 添加额外属性方法
func associatedObject<ValueType: Any>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}
func associateObject<ValueType: Any>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

//MARK: - 获取百分比宽高
func height(withRatio ratio: CGFloat) -> CGFloat {
    return ScreenHeight*ratio*0.01
}

func width(withRatio ratio: CGFloat) -> CGFloat {
    return ScreenWidth*ratio*0.01
}
