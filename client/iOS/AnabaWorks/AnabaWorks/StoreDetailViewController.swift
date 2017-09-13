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

class StoreDetailViewController: UIViewController {
  
  weak var store_detail: storeDetail?

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let store_detail_unwrapped = store_detail {
      let url = "https://anaba-works.herokuapp.com/api/envrioments/recent_data/"
      Alamofire.request(url, parameters: ["sensor_mac_address": store_detail_unwrapped.])
        .responseJSON(completionHandler: { response in

      
      
    }

  }
  @IBOutlet weak var wifi_mark: UIImageView!
  @IBOutlet weak var power_mark: UIImageView!
  @IBOutlet weak var tobacco_mark: UIImageView!

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
