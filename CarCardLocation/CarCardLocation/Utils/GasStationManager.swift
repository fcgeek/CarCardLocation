//
//  GasStationManager.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/16.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import Pantry
import CoreLocation
import RealmSwift

protocol GasStationManagerDelegate: class {
    func gasStationManagerWillChangeGasStations(_ manager: GasStationManager)
    func gasStationManager(_ manager: GasStationManager, didAddGasStation latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String)
}

class GasStationManager {
    
    var currentCity: CityModel? {
        didSet {
            guard let currentCity = currentCity else {
                return
            }
            Pantry.pack(currentCity, key: currentCityKey)
        }
    }
    private let currentCityKey = "currentCityKey"
    weak var delegate: GasStationManagerDelegate?
    
    static let shared = GasStationManager()
    
    private init() {
        currentCity = Pantry.unpack(currentCityKey)
    }
    
    
    
    func fetchGasStation(showInView inView: UIView?) {
        JSHelper.shared.getCurrentGasStations(inView: inView) { [weak self](gasStations) in
            guard let strong = self else { return }
            self?.delegate?.gasStationManagerWillChangeGasStations(strong)
            self?.fetchGasStationLocation(gasStations)
        }
    }
    
    //获取加油站地理编码位置
    func fetchGasStationLocation(_ gasStations: [GasStationModel]?) {
        let geocoder = CLGeocoder()
        DispatchQueue.global().async { [weak self] in
            guard let strong = self else { return }
            let sem = DispatchSemaphore(value: 0)
            var targetGasStations = gasStations ?? []
            let realm = try? Realm()
            var isRealm = false
            if gasStations == nil {
                isRealm = true
                targetGasStations = realm?.objects(GasStationModel.self).filter({$0.cityName == self?.currentCity?.name}) ?? []
            }
            for gasStation in targetGasStations {
                if gasStation.latitude > 0 {
                    self?.delegate?.gasStationManager(strong, didAddGasStation: gasStation.latitude, longitude: gasStation.longitude, name: gasStation.name)
                    continue
                    
                } else if !isRealm,
                    let exsitGasStation = realm?.object(ofType: GasStationModel.self, forPrimaryKey: gasStation.address),
                    exsitGasStation.latitude > 0 {
                    self?.delegate?.gasStationManager(strong, didAddGasStation: exsitGasStation.latitude, longitude: exsitGasStation.longitude, name: exsitGasStation.name)
                    continue
                }
                let updateGasStation = GasStationModel(gasStation: gasStation)
                updateGasStation.cityName = self?.currentCity?.name ?? ""
                geocoder.geocodeAddressString("\(self?.currentCity?.name ?? "")\(gasStation.address)", completionHandler: { (placemarks, error) in
                    let updateRealm = try? Realm()
                    if error == nil, let coordinate = placemarks?.first?.location?.coordinate {
                        updateGasStation.latitude = coordinate.latitude
                        updateGasStation.longitude = coordinate.longitude

                        self?.delegate?.gasStationManager(strong, didAddGasStation: coordinate.latitude, longitude: coordinate.longitude, name: updateGasStation.name)
                    } else {
                        print("\(self?.currentCity?.name ?? "")\(updateGasStation.address)")
                    }
                    try? updateRealm?.write {
                        updateRealm?.add(updateGasStation, update: true)
                    }
                    sem.signal()
                })
                sem.wait()
            }
        }
    }
}
