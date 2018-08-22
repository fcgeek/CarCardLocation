//
//  MapHelper.swift
//  PinXiaoTu
//
//  Created by liujianlin on 2018/5/19.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit
import MapKit

class MapHelper {

    static let shared = MapHelper()
    private init() {}
    
    func getMapSheet(withTitle title: String?, lat: CGFloat?, lng: CGFloat?) -> UIAlertController {
        let latitude = lat ?? 0
        let longitude = lng ?? 0
        let toTitle = title ?? ""
        let mapSheet = UIAlertController(title: "选择导航", message: nil, preferredStyle: .actionSheet)

        if UIApplication.shared.canOpenURL(URL(string:"qqmap://")!) {
            let action = UIAlertAction.init(title: "腾讯地图", style: .default) { (_) in
                let params = "from=我的位置&type=drive&tocoord=\(latitude),\(longitude)&to=\(toTitle)&coord_type=1&policy=0"
                let urlString = "qqmap://map/routeplan?\(params.urlEncoded())"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            mapSheet.addAction(action)
        }
        
        if UIApplication.shared.canOpenURL(URL(string:"iosamap://")!) {
            let action = UIAlertAction.init(title: "高德地图", style: .default) { (_) in
                let params = "sourceApplication=\(AppInfo.name)&dname=\(toTitle)&dlat=\(latitude)&dlon=\(longitude)&dev=0&t=0"
                let urlString = "iosamap://path?\(params.urlEncoded())"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            mapSheet.addAction(action)
        }
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            let action = UIAlertAction.init(title: "Google地图", style: .default) { (_) in
                let params = "x-source=\(AppInfo.name)&x-success=\(appScheme)&saddr=&daddr=\(toTitle)&center=\(latitude),\(longitude)&directionsmode=driving"
                let urlString = "comgooglemaps://?\(params.urlEncoded())"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            mapSheet.addAction(action)
        }
        
        if UIApplication.shared.canOpenURL(URL(string:"baidumap://")!) {
            let action = UIAlertAction.init(title: "百度地图", style: .default) { (_) in
                let params = "origin={{我的位置}}&destination=latlng:\(latitude),\(longitude)|name:\(toTitle)&mode=driving&coord_type=gcj02&src=\(AppInfo.name)"
                let urlString = "baidumap://map/direction?\(params.urlEncoded())"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            mapSheet.addAction(action)
        }
        
        let action = UIAlertAction.init(title: "苹果地图", style: .default) { (_) in
            let loc = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem(placemark:MKPlacemark(coordinate:loc,addressDictionary:nil))
            toLocation.name = toTitle
            MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: NSNumber(value: true)])
        }
        mapSheet.addAction(action)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        mapSheet.addAction(cancelAction)
        
        return mapSheet
    }
}
