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
private let kPersonMapAnimationTime = 0.300

class MyAnnotationView: MKAnnotationView {
  weak var customCalloutView: MyCalloutView?
  weak var storeDetailDelegate: MyCalloutViewDelegate?

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
    self.image = setImage(hasSensor: ((annotation as! MyAnnotation).store_detail.has_Sensor))
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.canShowCallout = false // This is important: Don't show default callout.
    self.image = setImage(hasSensor: false)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
      
      if let newCustomCalloutView = loadPersonDetailMapView() {
        // fix location from top-left to its right place.
        newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
        newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
        
        // set custom callout view
        self.addSubview(newCustomCalloutView)
        self.customCalloutView = newCustomCalloutView
        
        // animate presentation
        if animated {
          self.customCalloutView!.alpha = 0.0
          UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
            self.customCalloutView!.alpha = 1.0
          })
        }
      }
    } else {
      if customCalloutView != nil {
        if animated { // fade out animation, then remove it.
          UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
            self.customCalloutView!.alpha = 0.0
          }, completion: { (success) in
            self.customCalloutView!.removeFromSuperview()
          })
        } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
      }
    }
  }
  
  func loadPersonDetailMapView() -> MyCalloutView? {
    if let views = Bundle.main.loadNibNamed("MyCalloutView", owner: self, options: nil) as? [MyCalloutView], views.count > 0 {
      let personDetailMapView = views.first!
      if let myAnnotation = annotation as? MyAnnotation {
        personDetailMapView.delegate = self.storeDetailDelegate
        personDetailMapView.confirureWithInfo(store_detail: myAnnotation.store_detail, title: myAnnotation.store_detail.title!,
                                              address: myAnnotation.store_detail.address!, descrption: myAnnotation.store_detail.desc!)
      }
      return personDetailMapView
    }
    return nil
  }
  
  func setImage(hasSensor: Bool) -> UIImage {
    if hasSensor {
      return kSensorMapPinImage!
    }
    else {
      return kNosensorMapPinImage!
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    // if super passed hit test, return the result
    if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
    else { // test in our custom callout.
      if customCalloutView != nil {
        return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
      } else { return nil }
    }
  }

}
