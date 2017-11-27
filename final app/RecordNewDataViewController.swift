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
    @IBAction func startButtonTapped(_ sender: UIButton) {
        runTimer()
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        

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
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
    }

}
