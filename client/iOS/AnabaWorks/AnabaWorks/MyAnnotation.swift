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
  open var store_detail: storeDetail
  open var coordinate: CLLocationCoordinate2D
  
  init(coord: CLLocationCoordinate2D, store_detail: storeDetail){
    self.store_detail = store_detail
    self.coordinate = coord
  }
}
