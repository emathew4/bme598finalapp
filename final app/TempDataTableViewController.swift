//
//  TempDataTableViewController.swift
//  final app
//
//  Created by Ethan Mathew on 11/28/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class TempDataTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var temps = [TempData]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        navigationItem.rightBarButtonItem = editButtonItem
        
        if let savedTemps = loadTemps() {
            temps = savedTemps
        } else {
            temps = [TempData]()
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TempDataTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TempDataTableViewCell

        // Configure the cell...
        let tempData = temps[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = tempData.date
        let dateString = formatter.string(from: date)
        cell.tempDate.text = dateString
        
        cell.tempLength.text = "\(tempData.time.last!) s  "
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            temps.remove(at: indexPath.row)
            saveTemps()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Get the new view controller using segue.destinationViewController.
        let nextViewController = segue.destination as! BarChartViewController
        let selectedTempDataCell = sender as! TempDataTableViewCell
        let indexPath = tableView.indexPath(for: selectedTempDataCell)
        // Pass the selected object to the new view controller.
        let selectedTempData = temps[(indexPath?.row)!]
        nextViewController.tempData = selectedTempData
    }
    
    
    //MARK: Private Methods
    
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
    
    //Saving and Loading
    
    private func saveTemps() {
        let _ = NSKeyedArchiver.archiveRootObject(temps, toFile: TempData.ArchiveURL.path)
    }
    
    private func loadTemps() -> [TempData]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TempData.ArchiveURL.path) as? [TempData]
    }

}
