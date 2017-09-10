//
//  MyCalloutView.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/05.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit

protocol MyCalloutViewDelegate: class {
  func detailsRequestedForStore(store_detail: storeDetail)
}

class MyCalloutView: UIView {

  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var address: UILabel!
  @IBOutlet weak var this_description: UILabel!
  weak var delegate: MyCalloutViewDelegate?
  var store_detail: storeDetail?

  
  /*
  // Only override draw() if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
      // Drawing code
  }
  */
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func confirureWithInfo(store_detail: storeDetail, title: String, address: String, descrption: String) {
    self.store_detail = store_detail
    self.title.text = title
    self.address.text = address
    self.this_description.text = descrption
  }
  @IBAction func getDetailsButton(_ sender: Any) {
    if let store_detail_unwrapped = store_detail {
      delegate?.detailsRequestedForStore(store_detail: store_detail_unwrapped)
    }
  }
}
