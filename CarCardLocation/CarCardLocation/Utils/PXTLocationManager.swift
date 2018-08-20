//
//  PXTLocationManager.swift
//  PinXiaoTu
//
//  Created by liujianlin on 2018/5/7.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit
import CoreLocation

///结果回调
protocol PXTLocationManagerDelegate: class {
    func pxtLocationManagerDidSuccess(_ manager: PXTLocationManager)
    func pxtLocationManagerDidReject(_ manager: PXTLocationManager)
    func pxtLocationManager(_ manager: PXTLocationManager, didUnknown reason: String)
    func pxtLocationManagerDidAuthSuccess(_ manager: PXTLocationManager)
}

//地理位置管理
class PXTLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = PXTLocationManager()
    
    private let manager = CLLocationManager()
    
    var latitude: Double = 0
    var longitude: Double = 0
    weak var delegate: PXTLocationManagerDelegate?
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()        
    }
    
    func start() {
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            delegate?.pxtLocationManagerDidAuthSuccess(self)
            
        case .denied:
            delegate?.pxtLocationManagerDidReject(self)
            
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stop()
        if let loc2D = manager.location?.coordinate {
            latitude = loc2D.latitude
            longitude = loc2D.longitude
            delegate?.pxtLocationManagerDidSuccess(self)
        } else {
            delegate?.pxtLocationManager(self, didUnknown: "未知位置\ndidUpdateLocations")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stop()
        if let error = error as? CLError {
            switch error {
            case CLError.locationUnknown:
                delegate?.pxtLocationManager(self, didUnknown: "未知位置\n\(error.localizedDescription)")
                
            case CLError.denied:
                delegate?.pxtLocationManagerDidReject(self)
                
            default:
                delegate?.pxtLocationManager(self, didUnknown: error.localizedDescription)
            }
        }
    }
}
