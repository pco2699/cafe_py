//
//  storeDetail.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/07.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import Foundation

class storeDetail: NSObject {
  var has_Sensor: Bool
  var title: String?
  var address: String?
  var desc: String?
  
  init(has_Sensor: Bool, title: String, address: String, desc: String) {
    self.has_Sensor = has_Sensor
    self.title = title
    self.address = address
    self.desc = desc
  }
  override var description: String { return "Hoge" }
}
