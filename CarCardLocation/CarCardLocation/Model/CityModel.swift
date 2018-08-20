//
//  CityModel.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/15.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import Pantry

class CityModel: Storable, FCCodable {
    
    var name: String!
    var link: String!
    
    required init?(warehouse: Warehouseable) {
        name = warehouse.get("name") ?? ""
        link = warehouse.get("link") ?? ""
    }
    
    public func toDictionary() -> [String : Any] {
        return ["link": link,
                "name": name]
    }
}
