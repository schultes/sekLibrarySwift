//
//  TPLocation.swift
//  PluginsForIOSLibrary
//
//  Created by FMA1 on 09.06.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation

/**
This class holds basic position-related data
- Parameter time: Time in ms calculated from 01.01.1970 00:00 am
- Parameter latitude: Latitude
- Parameter longitude: Longitude
- Parameter altitude: Altitude
- Parameter speed: Instantaneous velocity in m/s
- Parameter accuracy: Position accuracy
*/
public struct TPLocation {
    /// Time in ms calculated from 01.01.1970 00:00 am
    public let time: Double
    /// Latitude
    public let latitude: Double
    /// Longitude
    public let longitude: Double
    /// Altitude
    public let altitude: Double
    /// Instantaneous velocity in m/s
    public let speed: Double
    /// Position accuracy
    public let accuracy: Double
    
    /**
    * Returns the object variables as a complete string
    */
    public func toString() -> String! {
        return "time: \(time); latitude: \(latitude); longitude: \(longitude); altitude: \(altitude); speed: \(speed); accuracy: \(accuracy)"
    }
}
