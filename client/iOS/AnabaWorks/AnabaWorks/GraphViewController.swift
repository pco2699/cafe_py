//
//  GraphViewController.swift
//  AnabaWorks
//
//  Created by pco2699 on 2017/09/17.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import AlamofireObjectMapper
import SwiftDate

class GraphViewController: UIViewController {
  
  var store_detail: storeDetail?
  var resultArray: [EnviromentData]?
  
  @IBOutlet weak var temp_chart: LineChartView!
  @IBOutlet weak var humid_chart: LineChartView!
  @IBOutlet weak var loudness_chart: LineChartView!
  @IBOutlet weak var air_quality_chart: LineChartView!
  @IBOutlet weak var light_chart: LineChartView!
  

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // 現在日付の取得
    let now_string = Date().string(format: .custom("YYYY-MM-dd HH:mm"))
    let before_string = (Date() - 1.day).string(format: .custom("YYYY-MM-dd HH:mm"))
    
    if let store_detail = store_detail {
      let url = "https://anaba-works.herokuapp.com/api/environments/"
      Alamofire.request(url, parameters: ["time_0": before_string, "time_1": now_string, "place": store_detail.sensor_mac_address])
        .responseArray{ (response: DataResponse<[EnviromentData]>) in
          self.resultArray = response.result.value
          if let resultArray = self.resultArray {
            var entryDict: Dictionary<String, [ChartDataEntry]> = [:]
            entryDict["Temperature"] = [ChartDataEntry]()
            entryDict["Humid"] = [ChartDataEntry]()
            entryDict["Light"] = [ChartDataEntry]()
            entryDict["Loudness"] = [ChartDataEntry]()
            entryDict["Air Quality"] = [ChartDataEntry]()
            
            var labels: [String] = []
            
            for i in 0..<resultArray.count {
              let temp_value = ChartDataEntry(x: Double(i), y:resultArray[i].temp)
              entryDict["Temperature"]?.append(temp_value)
              
              let humid_value = ChartDataEntry(x: Double(i), y:resultArray[i].humid)
              entryDict["Humid"]?.append(humid_value)
              
              let light_value = ChartDataEntry(x: Double(i), y:Double(resultArray[i].light_calculated))
              entryDict["Light"]?.append(light_value)
              
              let air_value = ChartDataEntry(x: Double(i), y:Double(resultArray[i].air_cleaness_caluclated))
              entryDict["Air Quality"]?.append(air_value)
              
              let loudness_value = ChartDataEntry(x: Double(i), y:Double(resultArray[i].loudness_caluclated))
              entryDict["Loudness"]?.append(loudness_value)
              
              labels.append(resultArray[i].time)
            }
            
            for(key, items) in entryDict {
              switch key {
                case "Temperature":
                  self.setChart(result: items, title: key, labels: labels, chart: self.temp_chart, color: NSUIColor.blue)
                case "Humid":
                  self.setChart(result: items, title: key, labels: labels, chart: self.humid_chart, color: NSUIColor.blue)
                case "Light":
                  self.setChart(result: items, title: key, labels: labels, chart: self.light_chart, color: NSUIColor.blue)
                case "Air Quality":
                  self.setChart(result: items, title: key, labels: labels, chart: self.air_quality_chart, color: NSUIColor.blue)
                case "Loudness":
                  self.setChart(result: items, title: key, labels: labels, chart: self.loudness_chart, color: NSUIColor.blue)
              default:
                  break
              }
            }
          }
      }
    }
  }
  
  func setChart(result: [ChartDataEntry], title: String, labels:[String], chart:LineChartView?, color: NSUIColor){
      let line1 = LineChartDataSet(values: result, label: title)
      line1.mode = .cubicBezier
      line1.drawCirclesEnabled = false
      line1.colors = [color]
    
      let data = LineChartData()
      data.addDataSet(line1)
      chart?.data = data
      chart?.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
      chart?.xAxis.drawLabelsEnabled = false
      chart?.xAxis.drawGridLinesEnabled = false
      chart?.xAxis.granularity = 1
      chart?.leftAxis.drawGridLinesEnabled = false
      chart?.chartDescription?.enabled = false
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
}



public class LineChartFormatter: NSObject, IAxisValueFormatter{
  // x軸のラベル
  var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  
  // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
  public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    // 0 -> Jan, 1 -> Feb...
    return months[Int(value)]
  }
}
