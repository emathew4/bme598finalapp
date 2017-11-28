//
//  RecordNewDataViewController.swift
//  final app
//
//  Created by Ethan Mathew on 11/20/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK
import CoreBluetooth

class RecordNewDataViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, PTDBeanManagerDelegate, PTDBeanDelegate  {
    
    //MARK: Properties
    
    var seconds = 30
    var timer = Timer()
    var isTimerRunning = false
    var beanManager: PTDBeanManager?
    var yourBean: PTDBean?
    var lightState: Bool = false
    var newTemp: Double = 1
    var isBluetoothOn = false
    
    @IBOutlet weak var ledTextLabel: UILabel!
    var manager:CBCentralManager?
    var peripheral:CBPeripheral!
    let BEAN_NAME = "Fahhad'sBean"
    let BEAN_SCRATCH_UUID =
        CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let BEAN_SERVICE_UUID =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    var FinalTempArray: [Double] = []
    
    @IBOutlet weak var timerLabel: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    //Scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                central.scanForPeripherals(withServices: nil, options: nil)
                isBluetoothOn = true
                print("Starting scan")
            } else {
                isBluetoothOn = false
                
                let bluetoothAlert = UIAlertController(title: "Bluetooth", message: "Please turn your Bluetooth on", preferredStyle: UIAlertControllerStyle.alert)
                bluetoothAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(bluetoothAlert, animated: true, completion: nil)
                print("Bluetooth not available.")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Connecting
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        print(advertisementData)
        if device?.contains(BEAN_NAME) == true {
            self.manager?.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager?.connect(peripheral, options: nil)
            // we added he below line to connect to th ebean to alow it to light!
            var error: NSError?
            beanManager!.connect(to: yourBean, withOptions: nil, error: &error)
            
            print("connected to \(peripheral)")
        }
    }
    
    // Getting services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("Connected")
    }
    
    //Getting charectristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == BEAN_SERVICE_UUID {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
    
    
    // Setting up notifications
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == BEAN_SCRATCH_UUID {
                self.peripheral.setNotifyValue(
                    true,
                    for: thisCharacteristic
                )
            }
        }
    }
    
    
    // Getting changes
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
        if characteristic.uuid == BEAN_SCRATCH_UUID {
            
            
            var tempA = characteristic.value
            print(tempA as! NSData)
            
            let value = tempA?.withUnsafeMutableBytes{(ptr: UnsafeMutablePointer<Double>) ->Double in return ptr.pointee}
            newTemp = value!*24/(1.1363509854348671e-322)
            
            
            
            
        }
        
    }
    
    // LED functions
    func sendSerialData(beanState: NSData) {
        yourBean?.sendSerialData(beanState as Data!)
    }
    
    func updateLedStatusText(lightState: Bool) {
        let onOffText = lightState ? "ON" : "OFF"
        ledTextLabel.text = "Device is: \(onOffText)"
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        // sending serial data to bean for commands
        
        lightState = !lightState
        updateLedStatusText(lightState: lightState)
        let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        sendSerialData(beanState: data)
        
        
        FinalTempArray.removeAll()
        
        if isTimerRunning == false {
            if let text = timerLabel.text, !text.isEmpty{
                let number: Int = {Int(self.timerLabel.text!)!}()
                seconds = number} else {
                seconds = 30
            }
            runTimer()
            timerLabel.isUserInteractionEnabled = false
            self.startButton.isEnabled = false
            
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        isTimerRunning = false
        startButton.isEnabled = true
        stopButton.isEnabled = false
        timerLabel.isUserInteractionEnabled = true
        
        
        lightState = !lightState
        updateLedStatusText(lightState: lightState)
        let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        sendSerialData(beanState: data)
        print(FinalTempArray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        stopButton.isEnabled = false
        addDoneButtonOnKeyboard()
        
        manager = CBCentralManager(delegate: self, queue: nil)
        beanManager = PTDBeanManager()
        beanManager!.delegate = self

        
        
        // Do any additional setup after loading the view.
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
    
    // implement back button functionality
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton.png"), for: .normal)
        backButton.setTitle(" Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Timer methods
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(RecordNewDataViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        stopButton.isEnabled = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            stopButtonTapped(stopButton)
        } else {
            seconds -= 1
            timerLabel.text = timeString(time:TimeInterval(seconds))
            FinalTempArray.append(newTemp)
        }
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let seconds = Int(time)
        
        return String(format: "%00002i", seconds)
    }
    
    //Add Done Button to Number Keyboard
    
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
        
        self.timerLabel.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.timerLabel.resignFirstResponder()
    }
    
}

