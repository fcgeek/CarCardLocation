//
//  CaseCountable.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/16.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

//用于标记枚举类型为Int可以获得count
protocol CaseCountable: Hashable {
    static var count: Int { get }
    static var allType: [Self] { get }
}

extension CaseCountable where Self : RawRepresentable, Self.RawValue == Int {
    /**
     自动获取枚举类型为Int，从0开始的count
     */
    static var count: Int {
        get {
            return Array(iterateEnum(Self.self)).count
        }
    }
    /**
     自动获取所有类型
     */
    static var allType: [Self] {
        get {
            let types = Array(iterateEnum(Self.self))
            return types
        }
    }
    
    var hashValue: Int {
        return rawValue
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension CaseCountable where Self : RawRepresentable, Self.RawValue == String {
    /**
     自动获取枚举类型为Int，从0开始的count
     */
    static var count: Int {
        get {
            return Array(iterateEnum(Self.self)).count
        }
    }
    /**
     自动获取枚举类型为Int，从0开始的所有类型
     */
    static var allType: [Self] {
        get {
            var types = [Self]()
            iterateEnum(Self.self).forEach { (type) in
                types.append(type)
            }
            return types
        }
    }
}
