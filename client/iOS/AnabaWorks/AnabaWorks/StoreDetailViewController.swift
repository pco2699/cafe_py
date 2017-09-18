//
//  StoreDetailViewController.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/07.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import Cartography

func constraintWithMultiplier(_ multiplier: CGFloat, org_constraint: NSLayoutConstraint) -> NSLayoutConstraint {
  return NSLayoutConstraint(item: org_constraint.firstItem, attribute: org_constraint.firstAttribute, relatedBy: org_constraint.relation, toItem: org_constraint.secondItem, attribute: org_constraint.secondAttribute, multiplier: multiplier, constant: org_constraint.constant)
}

class StoreDetailViewController: UIViewController {
  weak var store_detail: storeDetail?

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let store_detail = store_detail {
      // Store Detailの内容を設定
      self.store_label.text = store_detail.title
      self.wifi_mark.isHighlighted = store_detail.has_wifi
      self.power_mark.isHighlighted = store_detail.has_Sensor
      self.tobacco_mark.isHighlighted = store_detail.is_permitSmoking
      
      let url = "https://anaba-works.herokuapp.com/api/environments/recent_data/"
      Alamofire.request(url, parameters: ["place": store_detail.sensor_mac_address])
        .responseObject{ (response: DataResponse<EnviromentData>) in
          let EnviromentData = response.result.value
          if let EnviromentData = EnviromentData {
            // Enviromentデータをすべて画面に設定
            self.temp_label.text = String(describing: Int(EnviromentData.temp.rounded()))
            self.humid_label.text = String(describing: Int(EnviromentData.humid.rounded()))
            print(EnviromentData.loudness_caluclated)
            self.loudness_label.text = String(describing: EnviromentData.loudness_caluclated)
            self.air_quality_label.text = String(describing: EnviromentData.air_cleaness_caluclated)
            self.light_label.text = String(describing: EnviromentData.light_calculated)
            
            // 各パラメータの画面
            constrain(self.temp_red, self.temp_base){temp_red, temp_base in
              let ratio = CGFloat(EnviromentData.temp / 40)
              temp_red.width == temp_base.width * ratio
            }
            
            constrain(self.humid_graph, self.humid_base){graph, base in
              let ratio = CGFloat(EnviromentData.humid / 100)
              graph.width == base.width * ratio
            }
            
            constrain(self.loudness_graph, self.loudness_base){graph, base in
              let ratio = CGFloat(Double(EnviromentData.loudness_caluclated) / 100)
              graph.width == base.width * ratio
            }
            
            constrain(self.air_quality_graph, self.air_quality_base){graph, base in
              let ratio = CGFloat(Double(EnviromentData.air_cleaness_caluclated) / 100)
              graph.width == base.width * ratio
            }
            
            constrain(self.light_graph, self.light_base){graph, base in
              let ratio = CGFloat(Double(EnviromentData.light_calculated) / 100)
              graph.width == base.width * ratio
            }
            self.confort.text = EnviromentData.comfort
          }
      }
    }

  }
  @IBOutlet weak var wifi_mark: UIImageView!
  @IBOutlet weak var power_mark: UIImageView!
  @IBOutlet weak var tobacco_mark: UIImageView!
  
  @IBOutlet weak var confort: UILabel!
  
  @IBOutlet weak var loudness_label: UILabel!
  
  
  @IBOutlet weak var humid_label: UILabel!
  @IBOutlet weak var humid_base: UIImageView!
  @IBOutlet weak var humid_graph: UIImageView!
  
  
  
  @IBOutlet weak var air_quality_label: UILabel!
  @IBOutlet weak var air_quality_base: UIImageView!
  @IBOutlet weak var air_quality_graph: UIImageView!
  
  
  @IBOutlet weak var light_label: UILabel!
  @IBOutlet weak var light_base: UIImageView!
  @IBOutlet weak var light_graph: UIImageView!
  
  
  @IBOutlet weak var store_label: UILabel!
  
  @IBOutlet weak var temp_label: UILabel!
  @IBOutlet weak var temp_base: UIImageView!
  @IBOutlet weak var temp_red: UIImageView!
  
  @IBOutlet weak var loudness_base: UIImageView!
  @IBOutlet weak var loudness_graph: UIImageView!
  
  @IBOutlet weak var temp_width: NSLayoutConstraint!
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
