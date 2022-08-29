//
//  TPJSONObject.swift
//  PluginsForIOSLibrary
//
//  Created by Nicklas Düringer on 04.08.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation

/**
 This class represents a JSON-Object and provides various getter/setter.
- Parameter string: Accepts a valid JSON-String (optional)
*/
public class TPJSONObject {
    var data: [String: Any]
    
    init() {
        data = [:]
    }
    
    internal init(data: [String: Any]) {
        self.data = data
    }
    
    public convenience init(string: String) {
        if let data = string.data(using: .utf8) {
            self.init(data: data)
        } else {
            self.init()
        }
        
    }
    
    private convenience init(data: Data) {
        var tmp: [String: Any] = [:]
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                tmp = json
            }
            
        } catch {
        }
        self.init(data: tmp)
        
    }
    
    /**
     Inspects if key exists in JSON-Object
    - Parameter key: To be checked key
    - Returns: Boolean
    */
    public func has(key: String) -> Bool {
        return data[key] != nil && !(data[key] is NSNull)
    }
    
    /**
     Returns a value of type Any for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type Any or nil
    */
    public func getAny(key: String) -> Any? {
        if let value = data[key] {
            return value
        }
        return nil
    }
    
    /**
     Returns a value of type Integer for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type Integer or nil
    */
    public func getInt(key: String) -> Int? {
        if let value = data[key] as? Int {
            return value
        }
        return nil
    }
    
    /**
     Returns a value of type Double for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type Double or nil
    */
    public func getDouble(key: String) -> Double? {
        if let value = data[key] as? Double {
            return value
        }
        return nil
    }
    
    /**
     Returns a value of type Boolean for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type Boolean or nil
    */
    public func getBoolean(key: String) -> Bool? {
        if let value = data[key] as? Bool {
            return value
        }
        return nil
    }
    
    /**
     Returns a value of type String for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type String or nil
    */
    public func getString(key: String) -> String? {
        if let value = data[key] as? String {
            return value
        }
        return nil
    }
    
    /**
     Returns a value of type Date for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type Date or nil
    */
    public func getDate(key: String) -> Date? {
        if let value = data[key] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter.date(from: value)
        }
        return nil
    }
    
    /**
     Returns a value of type TPJSONObject for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type TPJSONObject or nil
    */
    public func getJSONObject(key: String) -> TPJSONObject? {
        if let value = data[key] as? [String: Any] {
            return TPJSONObject(data: value)
        }
        return nil
    }
    
    /**
     Returns a value of type TPJSONArray for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns the value of type TPJSONArray or nil
    */
    public func getJSONArray(key: String) -> TPJSONArray? {
        if let value = data[key] as? [Any] {
            return TPJSONArray(data: value)
        }
        return nil
    }
    
    /**
     Returns a list of Strings for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns a list of Strings or nil
    */
    public func getStringArray(key: String) -> [String]? {
        if let value = data[key] as? [String] {
            return value
        }
        return nil
    }
    
    /**
     Returns a list of Integers for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns a list of Integers or nil
    */
    public func getIntArray(key: String) -> [Int]? {
        if let value = data[key] as? [Int] {
            return value
        }
        return nil
    }
    
    /**
     Returns a list of Any for a given key, if it exists. Otherwise returns nil.
    - Parameter key: Name of the key
    - Returns: Returns a list of Any or nil
    */
    public func getAnyArray(key: String) -> [Any]? {
        if let value = data[key] as? [Any] {
            return value
        }
        return nil
    }
    
    /**
     Converts the given TPJSONObject to a Map.
    - Returns: Map of TPJSONObject
    */
    public func asMap() -> [String: Any] {
        return data
    }
    
    /**
     Sets value of type Any for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setAny(key: String, value: Any?) {
        data[key] = value
    }
    
    /**
     Sets value of type Integer for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setInt(key: String, value: Int?) {
        data[key] = value
    }
    
    /**
     Sets value of type Double for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setDouble(key: String, value: Double?) {
        data[key] = value
    }
    
    /**
     Sets value of type String for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setString(key: String, value: String?) {
        data[key] = value
    }
    
    /**
     Sets value of type Boolean for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setBoolean(key: String, value: Bool?) {
        data[key] = value
    }
    
    /**
     Sets value of type TPJSONObject for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setObject(key: String, value: TPJSONObject?) {
        data[key] = value?.data
    }
    
    /**
     Sets a list of TPJSONObjects for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setArray(key: String, value: [Any]?) {
        data[key] = value
    }
    
    /**
     Sets a list of Strings for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setStringArray(key: String, value: [String]?) {
        data[key] = value
    }
    
    /**
     Sets a list of Integers for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setIntArray(key: String, value: [Int]?) {
        data[key] = value
    }
    
    /**
     Sets a TPJSONArray for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setJSONArray(key: String, value: TPJSONArray?) {
        data[key] = value?.data
    }
    
    /**
     Sets a value of type Date for a given key
    - Parameter key: Key for which the value is to be set
    - Parameter value: Value to be set
    */
    public func setDate(key: String, value: Date?) {
        if let value = value {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            data[key] = dateFormatter.string(from: value)
            return
        }
        data[key] = nil
    }
    
    /**
     Returns the given TPJSONObject as Data
    */
    public func toData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return jsonData
        } catch {
            return nil
        }
    }
    
    /**
     Returns the given TPJSONObject as String
    */
    public func toString() throws -> String? {
        if let jsonData = toData() {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString.replacingOccurrences(of: "\\/", with: "/")
            }
        }
        return nil
    }
}
