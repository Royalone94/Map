//
//  FindString.swift
//  Saudi Organic Farming Association
//
//  Created by Mohamed Arafa on 7/16/18.
//  Copyright © 2018 Sawaqny. All rights reserved.
//

import UIKit

//show range of string
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
//usage
/*
 let s = "hello"
 s[0..<3] // "hel"
 s[3..<s.count] // "lo"
 */


//show if string contain some words
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
//usage
/*
 print(value.contains("Hello")) // true
 print(value.contains("bo"))    // false
 
 print(value.containsIgnoringCase(find: "hello"))    // true
 print(value.containsIgnoringCase(find: "Hello"))    // true
 */
