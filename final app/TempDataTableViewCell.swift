//
//  TempDataTableViewCell.swift
//  final app
//
//  Created by Ethan Mathew on 11/28/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class TempDataTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var tempDate: UILabel!
    @IBOutlet weak var tempLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
