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
    func gasStationManager(_ manager: GasStationManager, didAdd gasStation: GasStationModel)
}

class GasStationManager {
    
    var currentCity: CityModel? {
        didSet {
            guard let currentCity = currentCity else {
                return
            }
            Pantry.pack(currentCity, key: currentCityKey)
            let realm = try? Realm()
            gasStations = realm?.objects(GasStationModel.self).filter({$0.cityName == currentCity.name}) ?? []
        }
    }
    private let currentCityKey = "currentCityKey"
    private(set) var gasStations = [GasStationModel]()
    weak var delegate: GasStationManagerDelegate?
    
    static let shared = GasStationManager()
    
    private init() {
        currentCity = Pantry.unpack(currentCityKey)
        if let currentCity = currentCity {
            let realm = try? Realm()
            gasStations = realm?.objects(GasStationModel.self).filter({$0.cityName == currentCity.name}) ?? []
        }
    }
    
    func fetchGasStation(showInView inView: UIView?) {
        if gasStations.count > 0 {
            handleNewGasStations(gasStations)
            return
        }
        JSHelper.shared.getCurrentGasStations(inView: inView) { [weak self](gasStations) in
            guard let strong = self else { return }
            self?.gasStations = gasStations
            self?.delegate?.gasStationManagerWillChangeGasStations(strong)
            self?.handleNewGasStations(gasStations)
        }
    }
    
    private func handleNewGasStations(_ gasStations: [GasStationModel]) {
        let geocoder = CLGeocoder()
        DispatchQueue.global().async { [weak self] in
            guard let strong = self else { return }
            let sem = DispatchSemaphore(value: 0)
            for gasStation in gasStations {
                if let existGasStation = (try? Realm())?.object(ofType: GasStationModel.self, forPrimaryKey: gasStation.address),
                    existGasStation.latitude > 0 {
                    self?.delegate?.gasStationManager(strong, didAdd: existGasStation)
                    continue
                }
                geocoder.geocodeAddressString("\(self?.currentCity?.name ?? "")\(gasStation.address)", completionHandler: { (placemarks, error) in
                    if error == nil {
                        guard let coordinate = placemarks?.first?.location?.coordinate else { return }
                        gasStation.latitude = coordinate.latitude
                        gasStation.longitude = coordinate.longitude
                        gasStation.cityName = self?.currentCity?.name ?? ""
                        let realm = try? Realm()
                        try? realm?.write {
                            realm?.add(gasStation, update: true)
                        }
                        self?.delegate?.gasStationManager(strong, didAdd: gasStation)
                    } else {
                        print("\(self?.currentCity?.name ?? "")市\(gasStation.address)")
                    }
                    sem.signal()
                })
                sem.wait()
            }
        }
    }
}
