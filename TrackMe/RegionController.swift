//
//  RegionController.swift
//  Capstone
//
//  Created by Joshua Bates on 7/5/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CloudKit
import MapKit

class RegionController {
    
    static func createRegion(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, name: String, status: Bool = true) {
        // MARK: Starts Monitoring Region
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: name)
        guard let delegate = (UIApplication.sharedApplication().delegate as? AppDelegate) else { return }
        delegate.setUpRegions()
        let manager = delegate.manager
        manager.startMonitoringForRegion(region)
    }
    
    static func askForLocationPermissions() {
        guard let manager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.manager else { return }
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            manager.startUpdatingLocation()
        }
        
    }
    
    static func geoCodeAddress(address: String, geoCoder: CLGeocoder, completion: (coordinate: CLLocationCoordinate2D?) -> Void){
        geoCoder.cancelGeocode()
        geoCoder.geocodeAddressString(address) { placemarkers, error in
            if let error = error {
                AlertController.displayError(error, withMessage: nil)
                completion(coordinate: nil)
            } else {
                let placemark = placemarkers?.first
                completion(coordinate: placemark?.location?.coordinate)
            }
        }
    }
    
}
