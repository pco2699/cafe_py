//
//  MyAnnotation.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/02.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
  open var has_Sensor: Bool
  open var coordinate: CLLocationCoordinate2D
  
  init(sensor: Bool, coord: CLLocationCoordinate2D){
    self.has_Sensor = sensor
    self.coordinate = coord
  }
}
