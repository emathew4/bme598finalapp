//
//  ChartViewController.swift
//  final app
//
//  Created by Ethan Mathew on 11/27/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    var tempData: TempData?
    var time:[Int] = []
    var stringTimes:[String] = []
    var temperature:[Double] = []
    var points:[Double] = []
    var dataEntries: [ChartDataEntry] = []
 

    @IBOutlet weak var lineView: LineChartView!
    @IBOutlet weak var selectedTime: UITextField!
    @IBOutlet weak var displayedTemp: UILabel!
    @IBOutlet weak var averageTemp: UILabel!
    
    @IBAction func savesChart(_ sender: UIBarButtonItem) {
        let img = lineView.getChartImage(transparent: false)
        UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
        let chartAlert = UIAlertController(title: "Chart Saved", message: "Your chart was saved to your images!", preferredStyle: UIAlertControllerStyle.alert)
        chartAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(chartAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Data Source
        if let tempData = tempData {
            time = tempData.time
            for i in 0..<time.count {
                stringTimes.append("\(time[i])")
            }
            temperature = tempData.tempArray
            
            var total = 0.0
            for temp in temperature {
                total += temp
            }
            let tempAvg = total/Double(temperature.count)
            let tempAvgText = tempString(temp: tempAvg)
            averageTemp.text = tempAvgText + " °C"
        }
        addDoneButtonOnKeyboard()
        let initTemp = temperature[0]
        displayedTemp.text = tempString(temp: initTemp) + " °C"
        // Call function chart_Creation to create a bar chart
        chart_Creation(x: time, y: temperature)
    }
    
    
    func chart_Creation(x: [Int], y: [Double]) {
       
        
        lineView.noDataText = "You need to provide data for the chart."
        lineView.backgroundColor = UIColor.white
        
        for i in 0..<temperature.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: Double(temperature[i])))
            
        }
        
        let chart = LineChartDataSet(values: dataEntries, label: "Temperature")
        let line_Chart = LineChartData()
        line_Chart.addDataSet(chart)
        line_Chart.setDrawValues(false)
        line_Chart.setValueTextColor(UIColor.red)
        chart.colors = [UIColor.red]
        chart.setCircleColor(UIColor.red)
        chart.circleHoleColor = UIColor.red
        chart.fill = Fill.fillWithColor(UIColor.red)
        chart.drawFilledEnabled = true
        
        line_Chart.setValueFont(UIFont(name: "Verdana", size: 14.0)!)
        lineView.xAxis.valueFormatter = IndexAxisValueFormatter(values: stringTimes)
        lineView.xAxis.labelFont = UIFont(name: "Verdana", size: 15.0)!
        lineView.leftAxis.labelFont = UIFont(name: "Verdana", size: 15.0)!
        lineView.legend.font = UIFont(name: "Verdana", size: 15.0)!
        lineView.legend.textColor = UIColor.orange
        lineView.legend.enabled = false
        lineView.xAxis.drawGridLinesEnabled = false
        lineView.xAxis.labelPosition = .bottom
        lineView.xAxis.labelTextColor = UIColor.black
        lineView.xAxis.granularity = 1
        lineView.chartDescription?.enabled = false
        lineView.rightAxis.enabled = false
        lineView.leftAxis.drawGridLinesEnabled = false
        lineView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // Add limit line
        let limitLine = ChartLimitLine(limit: 20.0, label: "Threshold")
        limitLine.lineColor = UIColor.black
        limitLine.valueTextColor = UIColor.black
        lineView.leftAxis.addLimitLine(limitLine)
        lineView.leftAxis.labelTextColor = UIColor.black
        lineView.data = line_Chart
        
        
        /*
        barChartView.noDataText = "You need to provide data for the chart."
        
        for i in 0..<temperature.count {
            let dataEntry = BarChartDataEntry(x:Double(i), y: Double(temperature[i]))
            dataEntries.append(dataEntry)
            
        }
        let chart = BarChartDataSet(values: dataEntries, label: "Temperature")
        let chartData = BarChartData()
        chartData.addDataSet(chart)
        chartData.setDrawValues(true)
        chartData.setValueFont(UIFont(name: "Verdana", size: 14.0)!)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:stringTimes)
        // barChartView.xAxis.setLabelCount(months.count, force: true)
        barChartView.xAxis.labelFont = UIFont(name: "Verdana", size: 15.0)!
        barChartView.leftAxis.labelFont = UIFont(name: "Verdana", size: 15.0)!
        barChartView.legend.font = UIFont(name: "Verdana", size: 15.0)!
        barChartView.legend.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1
        barChartView.chartDescription?.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // Add limit line
        let limitLine = ChartLimitLine(limit: 10.0, label: "Temperature Threshold")
        barChartView.leftAxis.addLimitLine(limitLine)
        barChartView.data = chartData
        */
        
    }
    
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

    //MARK: Private Methods
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RecordNewDataViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.selectedTime.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        timeToTemp()
        self.selectedTime.resignFirstResponder()
    }
    
    func timeToTemp() {
        if let selectedTime = selectedTime.text, !selectedTime.isEmpty{
            let time: Int = {Int(self.selectedTime.text!)!}()
            if time > self.time.count-1 {
                let timeTooLargeAlert = UIAlertController(title: "Time Out of Bounds", message: "Please enter a valid time.", preferredStyle: UIAlertControllerStyle.alert)
                timeTooLargeAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.selectedTime.resignFirstResponder()
                self.present(timeTooLargeAlert, animated: true, completion: nil)
                displayedTemp.text = ""
                
            } else {
                let temp = tempString(temp: temperature[time])
                displayedTemp.text = temp + " °C"
            }
            
        }
    }
    
    func tempString(temp:TimeInterval) -> String {
        let temp = Double(temp)
        return String(format: "%.2f", temp)
    }
    
    
}
