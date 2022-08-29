//
//  TPJSONArray.swift
//  PluginsForIOSLibrary
//
//  Created by Nicklas Düringer on 04.08.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation

/**
 This class represents a JSON-Array and provides various getter/setter.
 - Parameter objects: Accepts a list of TPJSONObjects (optional)
 # Reference TPJSONObject
 */
public class TPJSONArray {
    var data: [Any]
    
    init() {
        self.data = []
    }
    
    init(data: [Any]) {
        self.data = data
    }
    
    init(objects: [TPJSONObject]) {
        self.data = objects.map { $0.data }
    }
    
    /**
     Returns the length of the given TPJSONArray
     - Returns: Length of the given TPJSONArray
     */
    func length() -> Int {
        return data.count
    }
    
    /**
     Returns a TPJSONObject for a given index
     - Parameter index: Index of the requested object
     - Returns: Object of type TPJSONObject
     # Reference TPJSONObject
     */
    public func getJSONObject(index: Int) -> TPJSONObject? {
        if index < data.count {
            if let value = data[index] as? [String: Any] {
                return TPJSONObject(data: value)
            }
        }
        return nil
    }
    
    /**
     Returns a String for a given index
    - Parameter index: Index of the requested string
    - Returns: Value of type String or null
    */
    public func getString(index: Int) -> String? {
        return data[index] as? String
    }

    /**
     Returns a value for a given index
    - Parameter index: Index of the requested value
    - Returns: Value of type Any or nil
    */
    public func get(index: Int) -> Any? {
        return data[index]
    }
    
    /**
     Creates a new array populated with the results of calling a provided function on every element (TPJSONObject) in the calling array.
     - Parameter mapCallback Callback function that should be executed on every element
     - Returns Newly created list.
     # Reference TPJSONObject
     */
    public func flatMap(transform: (TPJSONObject) throws -> TPJSONObject?) rethrows -> TPJSONArray {
        return TPJSONArray(objects: try data.compactMap { item in
            guard let data = item as? [String: Any] else { return nil }
            return try transform(TPJSONObject(data: data))
        })
    }
    
    /**
     Creates a new array populated with the results of calling a provided function on every element in the calling array.
     - Parameter mapCallback Callback function that should be executed on every element
     - Returns Newly created list.
     */
    public func map(_ transform: (Any) throws -> Any?) rethrows -> TPJSONArray {
        return TPJSONArray(data: try data.compactMap { item in
            guard let data = item as? [String: Any] else { return try transform(item) }
            return try transform(TPJSONObject(data: data))
        })
        }
    
    /**
    Returns the current array as a list of a given generic parameter.
    - Returns List of the given generic parameter
    # Reference TPJSONObject
    */
    public func asList<T>() throws -> [T]? {
        if let data = self.data as? [T] {
            return data
        }
        return nil
    }
    
    /**
     Returns the current array as a list of TPJSONObjects
     - Returns List of TPJSONObjects
     # Reference TPJSONObject
     */
    public func asJSONList() -> [TPJSONObject] {
        return data.compactMap { obj in
            guard let data = obj as? [String: Any] else { return nil }
            return TPJSONObject(data: data)
        }
    }
    
    /**
     Adds a TPJSONObject to the given TPJSONArray
     - Parameter object: TPJSONObject to be added
     */
    public func add(object: TPJSONObject) {
        self.data.append(object.data)
    }
    
    /**
     Adds a list of TPJSONObjects to the given TPJSONArray
     - Parameter objects: List of TPJSONObjects to be added
     */
    public func addAll(objects: [TPJSONObject]) {
        self.data.append(contentsOf: objects.map { $0.data })
    }
    
    /**
     Adds a list of Strings to the given TPJSONArray
    - Parameter objects: List of Strings to be added
    */
    public func addAllString(objects: [String]) {
        self.data.append(contentsOf: objects.map { $0 })
    }

    /**
     Adds a list of Integers to the given TPJSONArray
    - Parameter objects: List of Integers to be added
    */
    public func addAllInt(objects: [Int]) {
        self.data.append(contentsOf: objects.map { $0 })
    }

    /**
     Adds an Integer to the given TPJSONArray
    - Parameter value: Integer to be added
    */
    public func addInt(value: Int) {
        self.data.append(value)
    }

    /**
     Adds a Double to the given TPJSONArray
    - Parameter value: Double to be added
    */
    public func addDouble(value: Double) {
        self.data.append(value)
    }

    /**
     Adds a String to the given TPJSONArray
    - Parameter value: String to be added
    */
    public func addString(value: String) {
        self.data.append(value)
    }

    /**
     Adds a Boolean to the given TPJSONArray
    - Parameter value: Boolean to be added
    */
    public func addBoolean(value: Bool) {
        self.data.append(value)
    }
    
    /**
     Returns the given TPJSONArray as Data
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
     Returns the given TPJSONArray as String
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
