//
//  TempData.swift
//  final app
//
//  Created by Ethan Mathew on 11/20/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import Foundation

class TempData {
    
    //MARK: Properties
    
    var date: String
    var tempArray: [Float]
    var time: [Float]
    
    //MARK: Initialization
    
    init (date: String, tempArray: [Float], time: [Float]){
        self.date = date
        self.tempArray = tempArray
        self.time = time
    }
}
