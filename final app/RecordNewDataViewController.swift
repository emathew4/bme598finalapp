//
//  RecordNewDataViewController.swift
//  final app
//
//  Created by Ethan Mathew on 11/20/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class RecordNewDataViewController: UIViewController {
    
    //MARK: Properties
    
    var seconds = 30
    var timer = Timer()
    var isTimerRunning = false
    
    @IBOutlet weak var timerLabel: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
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
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        isTimerRunning = false
        startButton.isEnabled = true
        stopButton.isEnabled = false
        timerLabel.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        stopButton.isEnabled = false
        addDoneButtonOnKeyboard()

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
        } else {
            seconds -= 1
            timerLabel.text = timeString(time:TimeInterval(seconds))
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
