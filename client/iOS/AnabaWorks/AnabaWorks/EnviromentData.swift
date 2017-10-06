//
//  EnviromentData.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/14.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import Foundation
import ObjectMapper

enum Confort: Int {
  case high = 500
  case middle = 1000
  case low = 1500
}

class EnviromentData: Mappable {
  var place: String = ""
  var time: String = ""
  var temp: Double = 0.0
  var humid: Double = 0.0
  var light: Int = 0
  var loudness: Int = 0
  var air_cleaness: Int = 0
  var co2_ppm: Int = 0
  var no_of_person: Int = 0
  
  var light_calculated: Int { return caluclate_analog_signal(analog_signal: light)}
  var loudness_caluclated: Int { return caluclate_analog_signal(analog_signal: loudness)}
  var air_cleaness_caluclated: Int { return caluclate_analog_signal(analog_signal: air_cleaness)}
  var comfort: String {
    if 0...Confort.high.rawValue ~= co2_ppm {
      return "快適"
    }
    else if Confort.high.rawValue...Confort.middle.rawValue ~= co2_ppm {
      return "普通"
    }
    else if Confort.middle.rawValue...Confort.low.rawValue ~= co2_ppm {
      return "混雑"
    }
    else if Confort.low.rawValue <= co2_ppm {
      return "超混雑"
    }
    
    return "判定不能"
  }
		
  func caluclate_analog_signal(analog_signal: Int) -> Int {
    if (analog_signal == 0) {
      return 0
    }
    else {
      return Int((Double(analog_signal) / 1024 * 100).rounded())
    }
  }
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map){
    place <- map["place"]
    time <- map["time"]
    temp <- map["temp"]
    humid <- map["humid"]
    light <- map["light"]
    loudness <- map["loudness"]
    air_cleaness <- map["air_cleanness"]
    co2_ppm <- map["co2_ppm"]
    no_of_person <- map["no_of_person"]
  }
}
