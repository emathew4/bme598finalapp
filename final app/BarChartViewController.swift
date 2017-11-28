//
//  BarChartViewController.swift
//  final app
//
//  Created by Ethan Mathew on 11/27/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {

    var tempData: TempData?
    var time:[Int] = []
    var stringTimes:[String] = []
    var temperature:[Double] = []
    var points:[Double] = []
    var dataEntries: [BarChartDataEntry] = []
 
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var selectedTime: UITextField!
    @IBOutlet weak var displayedTemp: UILabel!
    
    @IBAction func timeToTemp(_ sender: UIButton) {
        if let selectedTime = selectedTime.text, !selectedTime.isEmpty{
            let time: Int = {Int(self.selectedTime.text!)!}()
            if time > self.time.count-1 {
                let timeTooLargeAlert = UIAlertController(title: "Time Out of Bounds", message: "Please enter a valid time.", preferredStyle: UIAlertControllerStyle.alert)
                timeTooLargeAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(timeTooLargeAlert, animated: true, completion: nil)
                displayedTemp.text = ""
                
            } else {
                displayedTemp.text = String(temperature[time])
            }
            
        } else {
            let emptyFieldAlert = UIAlertController(title: "Field is Empty", message: "Please enter a value above.", preferredStyle: UIAlertControllerStyle.alert)
            emptyFieldAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(emptyFieldAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func savesChart(_ sender: UIBarButtonItem) {
        let img = barChartView.getChartImage(transparent: false)
        UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
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
        }
        addDoneButtonOnKeyboard()
        // Call function chart_Creation to create a bar chart
        chart_Creation(x: time, y: temperature)
    }
    
    
    func chart_Creation(x: [Int], y: [Double]) {
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
        self.selectedTime.resignFirstResponder()
    }
    
    
}
