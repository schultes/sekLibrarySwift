//
//  TPLocationListener.swift
//  PluginsForIOSLibrary
//
//  Created by FMA1 on 12.06.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation
import CoreLocation

/**
* This class provides methods for location tracking of a user
*/
public class TPLocationListener: NSObject {
    
    private var distanceInMeters: Double = 1.0
    private var callback: ((_ location: TPLocation) -> Void)? = nil
    
    private let locationManager = CLLocationManager()
    private var isListeningOnce = false
    private var isListening = false
    private var lastKnownPosition: TPLocation? = nil
    
    /**
    Initialization of a TPLocationListener
    - Parameter distanceInMeters: Necessary distance that must be exceeded before changes are returned via the callback.
    - Parameter location: TPLocation object
    */
    public init(distanceInMeters: Double = 1.0) {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = distanceInMeters
        locationManager.requestAlwaysAuthorization()
        self.distanceInMeters = distanceInMeters
    }
    
    /**
    Setting a callback function via which TPLocation objects can be returned in the event of a position change.
    - Parameter callback: callback function that can be used to return a TPLocation object
     # Reference TPLocation
     */
    public func setCallback(callback: @escaping (_ location: TPLocation) -> Void) {
        self.callback = callback
    }
    
    
    /**
   If permission is granted, Location Listening is started and waits for position updates. Without appropriate authorization, Location Listening is not started and no error message is issued.
     
    # Reference TPLocation
    */
    public func startListeningForUpdates() {
        if TPLocationListener.hasPermission() && !isListening {
            self.isListening = true
            locationManager.startUpdatingLocation()
        } else if TPLocationListener.hasPermission() {
            if let position = lastKnownPosition {
                if let callback = callback {
                    callback(position)
                }
            }
            isListeningOnce = false
        }
    }

    /**
    Searches the current position and returns it via the callback
     
    # Reference TPLocation
    */
    public func getCurrentLocation() {
        isListeningOnce = true
        startListeningForUpdates()
    }
    
    /**
    * Stops all location updates
    */
    public func stopListeningForUpdates() {
        isListening = false
        isListeningOnce = false
        locationManager.stopUpdatingLocation()
    }
    
    /**
    If actively waiting for position changes, this function returns `true`,
    it will wait for changes as soon as the method `startListeningForUpdates()`
    has been called and has not been stopped by the method `stopListeningForUpdates()`.
    - Returns: `true` if position changes are waited for, otherwise `false`.
    */
    public func isListeningForUpdates() -> Bool {
        return isListening
    }
    
    /**
    Returns the last known position,
    if no position has been determined yet, `nil` is returned
    - Returns: TPLocation or nil
    # Reference TPLocation
    */
    public func getLastKnownLocation() -> TPLocation? {
        return lastKnownPosition
    }
    
    /**
    Checks if the permission was granted
    - Returns: `true` if the permission was granted, otherwise `false`.
    */
    public static func hasPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                default:
                    return false
            }
        }
        return false
    }
}

/// Extension for TPLocationListener to receive and process location changes
extension TPLocationListener: CLLocationManagerDelegate {
    
    /**
    This method is used internally and should not be called or overridden by the developer.
    - Parameter manager: CLLocationManager, which is responsible for receiving the location updates.
    - Parameter didUpdateLocations: list with location objects
    # Reference TPLocation
    */
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        lastKnownPosition = TPLocation(time: location.timestamp.timeIntervalSince1970, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude, speed: location.speed, accuracy: location.horizontalAccuracy)
        if let callback = callback {
            callback(lastKnownPosition!)
        }

        if(isListeningOnce) {
            stopListeningForUpdates()
        }
    }
}
