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
import AlamofireObjectMapper

extension UIImage {
  func resize(size _size: CGSize) -> UIImage? {
    let widthRatio = _size.width / size.width
    let heightRatio = _size.height / size.height
    let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
    
    let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    
    UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
    draw(in: CGRect(origin: .zero, size: resizedSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage
  }
}

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
    self.navigationItem.titleView = UIImageView(image:UIImage(named:"title")?.resize(size: CGSize(width: 100, height: 40)))
  }
  
  override func viewDidAppear(_ animated: Bool) {
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
      .responseArray { (response: DataResponse<[storeDetail]>) in

        let storeDetailArray = response.result.value
        
        if let storeDetailArray = storeDetailArray {
          for store_detail in storeDetailArray {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(store_detail.lat), longitude: CLLocationDegrees(store_detail.long))
            let pin = MyAnnotation(coord: coordinate, store_detail: store_detail)
            
            self.mapview.addAnnotation(pin)

          }
        }
      }
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
    if ((pinView?.annotation as? MyAnnotation)?.store_detail.has_Sensor)! {
      pinView?.image = UIImage(named: "Sensor")
    }
    else {
      pinView?.image = UIImage(named: "Nosensor")
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

