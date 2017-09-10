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

class FirstViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, MyCalloutViewDelegate {
  
  var locationManager: CLLocationManager!
  var selectedStore: storeDetail?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    // タップした時のアクションを追加
    // let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
    // mapview.addGestureRecognizer(tapGesture)
    
    // MapView Delegate設定
    mapview.delegate = self
    
    setupLocationManager()
    getLocation()
    mapview.showsUserLocation = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.mapview.region = MKCoordinateRegionMakeWithDistance(mapview.userLocation.coordinate, 500.0, 500.0)
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
  
  func getLocation() {
    let url = "https://anaba-works.herokuapp.com/api/places/"
    Alamofire.request(url)
      .responseJSON(completionHandler: { response in
        let json = JSON(response.result.value ?? "empty")
        json.forEach{(_, data) in
          let coordinate = CLLocationCoordinate2D(latitude: Double(data["lat"].string!)!, longitude: Double(data["long"].string!)!)
          let store_detail = storeDetail(has_Sensor: true, title: data["name"].string!, address: data["address"].string!, desc: data["sensor_mac_address"].string!)
          let pin = MyAnnotation(coord: coordinate, store_detail: store_detail)
          
          self.mapview.addAnnotation(pin)
          
        }
      })
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    if pinView == nil {
      pinView = MyAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      (pinView as? MyAnnotationView)?.storeDetailDelegate = self
      
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let store_detail_vc = segue.destination as? StoreDetailViewController {
      store_detail_vc.store_detail = self.selectedStore
    }
  }
  
  func detailsRequestedForStore(store_detail: storeDetail) {
    self.selectedStore = store_detail
    performSegue(withIdentifier: "detailSegue", sender: self)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let newLocation = locations.last else {
      return
    }
    
    self.mapview.region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500.0, 500.0)
    
  }


}

