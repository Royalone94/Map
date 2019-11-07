//
//  DroppablePin.swift
//  map deves
//
//  Created by Abdalla on 1/24/19.
//  Copyright © 2019 Abdalla. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
    
    var coordinate: CLLocationCoordinate2D
    var identifire: String
    var subtitle: String?
    var title: String?
    
    
    
    
    
    init(coordinate: CLLocationCoordinate2D, identifire: String, subtitle: String, title: String) {
        self.coordinate = coordinate
        self.identifire = identifire
        self.subtitle = subtitle
        self.title = title
        super.init()
    }
    
}
