//
//  TempData.swift
//  final app
//
//  Created by Ethan Mathew on 11/20/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import Foundation

class TempData: NSObject, NSCoding {
    
    //MARK: Properties
    
    var date: Date
    var tempArray: [Double]
    var time: [Int]
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("temps")
    
    //MARK: Types
    
    struct PropertyKey {
        static let date = "date"
        static let tempArray = "tempArray"
        static let time = "time"
    }
    
    //MARK: Initialization
    
    init (date: Date, tempArray: [Double], time: [Int]){
        self.date = date
        self.tempArray = tempArray
        self.time = time
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(tempArray, forKey: PropertyKey.tempArray)
        aCoder.encode(time, forKey: PropertyKey.time)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            return nil
        }
        
        guard let tempArray = aDecoder.decodeObject(forKey: PropertyKey.tempArray) as? [Double] else {
            return nil
        }
        
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? [Int] else {
            return nil
        }
        
        self.init(date: date, tempArray: tempArray, time: time)
    }
    
}
