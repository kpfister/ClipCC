//
//  Parser.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class Parser {
    // Our array of data points to display
    static var transactions = [TransactionDetail]()
    
    static func parseTransactions(tlvString: String, startIndex: Int = 0 ,startingLength: Int = 0) -> [TransactionDetail]  {
        // Tags can be either two or four character in legnth. theFirstTag is checking to see if the first two characters in the string can be read as a valid Tag
        let firstTag = tlvString.rangeOf(r: Range(startIndex...(startIndex + 1)))
        
        // If the first two characters can not make a tag - then the first four might be able too
        let secondTag = tlvString.rangeOf(r: Range(startIndex...(startIndex + 3)))
        
        /// Get tag
        let tagName = Tag.getTagName(tag: firstTag) ?? Tag.getTagName(tag: secondTag)
        let actualTag = Tag.getTagName(tag: firstTag) != nil ? firstTag : secondTag
        
        if tagName != nil {
            
            /// Get length
            let lengthStart = actualTag.count + startingLength
            // The legnth start takes in account the amount of characters in the tag along with where the last value ended
            let lengthEnd = (actualTag.count + 1) + startingLength
            // The legnth end takes in account the amount of characters in the tag along with where the last value ended while also disreguarding the first character in the length
            let hexLength = tlvString.rangeOf(r: Range(lengthStart...lengthEnd))
            // The hex value of the Length
            let length = Converter.hexToInt(hex: hexLength)
            // Converted hex to Int for use in the following equations
            /// Get value
            let value = tlvString.rangeOf(r: Range((lengthStart)...(length * 2) + lengthEnd))
            // Length is doubled as there are two bytes in each character
            let stringValue = Converter.hexToString(hex: value)
            // Convert the hex value into a String if possible
            let intValue = Converter.hexToInt(hex: value)
            // Convert the hex value into a Int if possible
            if intValue == 0 && stringValue == nil {
                // If the int value is 0 and the string value is nil - we want the value
                let td = TransactionDetail(tag: tagName!, tagDetail:actualTag, value: value)
                transactions.append(td)
            } else if intValue == 0 && stringValue != nil {
                // If the Int value can be converted into a 0 and the stringValue can be created - we want the string
                let td = TransactionDetail(tag: tagName!, tagDetail:actualTag, value: stringValue!)
                transactions.append(td)
            } else {
                // All that should be left is the IntValue case. Lets format the string to be more readable for what we expect
                let numberString = String(intValue, radix: 16)
                let formattedNumberString = numberString.dropFirst(1)
                
                let td = TransactionDetail(tag: tagName!, tagDetail:actualTag, value:formattedNumberString.uppercased())
                self.transactions.append(td)
            }
            
            /// Manage recursion
            // Total count for this transaction, and where the next transaction starts
            let endOfTransaction = (length * 2 + (lengthEnd + 1))
            if endOfTransaction != tlvString.count - 4 {
                parseTransactions(tlvString: tlvString, startIndex: endOfTransaction, startingLength: endOfTransaction)
                //MARK: - Improvement
                /// This has to possible to accomblish in a better way. We are not using the return of this value... I'll have to refactor this after I learn more.
            }
        }
        return self.transactions
    }
}

extension String {
    
    func rangeOf(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
}

