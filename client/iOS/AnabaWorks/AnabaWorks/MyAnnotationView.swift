//
//  MyAnnocationView.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/02.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import MapKit

private var kSensorMapPinImage = UIImage(named: "Sensor")
private var kNosensorMapPinImage = UIImage(named: "Nosensor")

class MyAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.canShowCallout = false
    self.image = setImage(hasSensor: ((annotation as! MyAnnotation).has_Sensor))
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.canShowCallout = false // This is important: Don't show default callout.
    self.image = setImage(hasSensor: false)
  }
  
  func setImage(hasSensor: Bool) -> UIImage {
    if hasSensor {
      return kSensorMapPinImage!
    }
    else {
      return kNosensorMapPinImage!
    }
  }

}
