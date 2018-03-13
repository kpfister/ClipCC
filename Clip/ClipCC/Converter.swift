//
//  Converter.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class Converter {
    
    class func hexToInt(hex: String) -> Int {
        guard let num = Int(hex, radix: 16) else { return 0}
        return num
    }
    
    class func hexToString(hex: String) -> String? {
        guard hex.count % 2 == 0 else {
            return nil
        }
        
        var bytes = [CChar]()
        
        var startIndex = hex.index(hex.startIndex, offsetBy: 2)
        while startIndex < hex.endIndex {
            let endIndex = hex.index(startIndex, offsetBy: 2)
            let substr = hex[startIndex..<endIndex]
            
            if let byte = Int8(substr, radix: 16) {
                bytes.append(byte)
            } else {
                return nil
            }
            
            startIndex = endIndex
        }
        
        bytes.append(0)
        return String(cString: bytes)
    }
}
