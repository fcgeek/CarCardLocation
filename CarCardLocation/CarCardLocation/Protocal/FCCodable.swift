//
//  FCCodable.swift
//  SiteBroswer
//
//  Created by liujianlin on 2017/10/27.
//  Copyright © 2017年 liujianlin. All rights reserved.
//

import UIKit

protocol FCCodable: Codable {}
extension FCCodable {
    static func decode(withJSONString jsonString: String) -> Self? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
