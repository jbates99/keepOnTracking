//
//  GeoFence + CloudKit.swift
//  Capstone
//
//  Created by Joshua Bates on 7/5/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

extension GeoFence {
    static var statusKey: String { return "status" }
    static var latKey: String { return "latitude" }
    static var longKey: String { return "longitude" }
    static var identifierKey: String { return "identifier" }
    static var radiusKey: String { return "radius" }
    static var recordType: String { return "GeoFence" }
    
    init?(cloudKitRecord: CKRecord) {
        guard let latitude = cloudKitRecord[GeoFence.latKey] as? Double,
            longitude = cloudKitRecord[GeoFence.longKey] as? Double,
            distance = cloudKitRecord[GeoFence.radiusKey] as? Double,
            identifier = cloudKitRecord[GeoFence.identifierKey] as? String,
            status = cloudKitRecord[GeoFence.statusKey] as? Bool where
            cloudKitRecord.recordType == GeoFence.recordType else { return nil }
        
        
        self.init(region: CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: CLLocationDegrees(distance), identifier: identifier), status: status, name: identifier)
    }

}


extension CKRecord {
    convenience init(geoFence: GeoFence) {
        self.init(recordType: GeoFence.recordType)
        self[GeoFence.statusKey] = geoFence.status
        self[GeoFence.identifierKey] = geoFence.region.identifier
        self[GeoFence.latKey] = geoFence.region.center.latitude
        self[GeoFence.longKey] = geoFence.region.center.longitude
        self[GeoFence.radiusKey] = Double(geoFence.region.radius)
    }
}
