//
//  LocationAnnotation.swift
//  2019S1 Lab 3
//
//  Created by ggguest on 2019/8/30.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//


import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var photo: NSData?
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double, newphoto: NSData) {
        self.title = newTitle
        self.subtitle = newSubtitle
        self.photo = newphoto
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}
