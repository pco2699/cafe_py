//
//  storeDetail.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/07.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import Foundation
import ObjectMapper

class storeDetail: Mappable {
  var has_Sensor: Bool = false
  var title: String = "No Title"
  var address: String = "No Address"
  var lat: NSDecimalNumber = 0.0
  var long: NSDecimalNumber = 0.0
  var desc: String = ""
  var sensor_mac_address: String = ""
  var has_wifi: Bool = false
  var has_power: Bool = false
  var is_permitSmoking: Bool = false
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map){
    lat <- (map["lat"], NSDecimalNumberTransform())
    long <- (map["long"], NSDecimalNumberTransform())
    has_Sensor <- map["has_sensor"]
    title <- map["name"]
    address <- map["address"]
    desc <- map["desc"]
    sensor_mac_address <- map["sensor_mac_address"]
    has_wifi <- map["has_wifi"]
    has_power <- map["has_power"]
    is_permitSmoking <- map["is_permitSmoking"]
    desc <- map["place_description"]
  }
}
