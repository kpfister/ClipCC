//
//  Parser.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class Parser {
    
    //static let sharedInstance = Parser()
    static var transactions = [TransactionDetail]()
    

    
    static func parseTransactions(tlvString: String, startIndex: Int = 0 ,startingLength: Int = 0) -> [TransactionDetail]  {

        let firstTag = tlvString.rangeOf(r: Range(startIndex...(startIndex + 1)))
        
        let secondTag = tlvString.rangeOf(r: Range(startIndex...(startIndex + 3)))
        
        /// Get tag

        var tagName = Tag.getTagName(tag: firstTag) ?? Tag.getTagName(tag: secondTag)
        let actualTag = Tag.getTagName(tag: firstTag) != nil ? firstTag : secondTag
        
        if tagName != nil {
        
        /// Get length
        let lengthStart = actualTag.count + startingLength
        
        let lengthEnd = (actualTag.count + 1) + startingLength
        
        let hexLength = tlvString.rangeOf(r: Range(lengthStart...lengthEnd))
        
        let length = Converter.hexToInt(hex: hexLength)
        
        /// Get value
        let value = tlvString.rangeOf(r: Range((lengthStart)...(length * 2) + lengthEnd))

        let stringValue = Converter.hexToString(hex: value)
            
        let intValue = Converter.hexToInt(hex: value)
        
        if intValue == 0 {
            //transactions.append(stringValue!)
           let td = TransactionDetail(name: tagName!, tagDetail:actualTag, value: stringValue!)
            
        } else {
            let numberString = String(intValue, radix: 16)
            let formattedNumberString = numberString.dropFirst(1)
            
            //transactions.append(String(formattedNumberString).uppercased())
            let td = TransactionDetail(name: tagName!, tagDetail:actualTag, value:formattedNumberString.uppercased())
           self.transactions.append(td)
            
        }
        
        print(self.transactions.last)
        //print(idk.last)
        // Manage recursion
        // Total count for this transaction, and where the next transaction starts
        let endOfTransaction = (length * 2 + (lengthEnd + 1))
        if endOfTransaction != tlvString.count - 4 {
            parseTransactions(tlvString: tlvString, startIndex: endOfTransaction, startingLength: endOfTransaction)
        }
        }
        return self.transactions
        }
}

extension String {
    
    func rangeOf(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        //print("The indexStart is \(start)")
        let end = index(startIndex, offsetBy: r.upperBound)
        //print("The indexEnd is \(end)")
        return String(self[Range(start ..< end)])
    }
}

