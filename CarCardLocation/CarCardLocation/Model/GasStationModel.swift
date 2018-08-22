//
//  GasStationModel.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/15.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class GasStationModel: Object, FCCodable {
    @objc dynamic var cityName: String = ""
    @objc dynamic var company: String = ""
    @objc dynamic var region: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    init(gasStation: GasStationModel) {
        super.init()
        cityName = gasStation.cityName
        company = gasStation.company
        region = gasStation.region
        name = gasStation.name
        address = gasStation.address
        latitude = gasStation.latitude
        longitude = gasStation.longitude
    }
    
    private enum CodingKeys: String, CodingKey {
        case company
        case region
        case name
        case address
    }
    
    override class func primaryKey() -> String? {
        return "address"
    }
}
