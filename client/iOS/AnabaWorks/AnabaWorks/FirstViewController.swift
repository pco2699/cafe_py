//
//  FirstViewController.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/08/28.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
  
  var locationManager: CLLocationManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    // タップした時のアクションを追加
    let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
    mapview.addGestureRecognizer(tapGesture)
    
    // MapView Delegate設定
    mapview.delegate = self
    
    setupLocationManager()
    
    getLocation()
  }
  
  func setupLocationManager() {
    locationManager = CLLocationManager()
    guard let locationManager = locationManager else { return }
    locationManager.requestWhenInUseAuthorization()
    
    let status = CLLocationManager.authorizationStatus()
    if status == .authorizedWhenInUse {
      locationManager.delegate = self
      locationManager.distanceFilter = 10
      locationManager.startUpdatingLocation()
    }
  }
  @IBOutlet weak var mapview: MKMapView!

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func mapTapped(_ sender: UILongPressGestureRecognizer){
    // タッチ終了か？
    if sender.state == .ended {
      print("tapp")
      // 画面上のタッチした座標を取得
      let tapPoint = sender.location(in: mapview)
      // タッチした座標からマップ上の緯度経度を取得
      _ = mapview.convert(tapPoint, toCoordinateFrom: mapview)
      
      self.mapview.removeOverlays(mapview.overlays)
      self.mapview.removeAnnotations(mapview.annotations)
      
      // getLocation(location)
    }
  }
  
  func getLocation() {
    let url = "https://anaba-works.herokuapp.com/api/places/"
    Alamofire.request(url)
      .responseJSON(completionHandler: { response in
        let json = JSON(response.result.value ?? "empty")
        json.forEach{(_, data) in
          print(data["has_wifi"])
          let cordinate = CLLocationCoordinate2D(latitude: Double(data["lat"].string!)!, longitude: Double(data["long"].string!)!)
          let pin = MyAnnotation(sensor: true, coord: cordinate)
          
          self.mapview.addAnnotation(pin)
          
        }
      })
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MyAnnotationView
    if pinView == nil {
      pinView = MyAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//      pinView?.animatesDrop = true
    }
    else {
      pinView?.annotation = annotation
    }
    
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let pin = view.annotation
    if let new_pin = pin {
      if let new_subtitle = new_pin.subtitle {
        let url_obj = URL(string: new_subtitle!)
        let app: UIApplication = UIApplication.shared
        app.open(url_obj!)
      }
    }
  }
  
  


}

