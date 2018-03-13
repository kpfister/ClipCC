//
//  Parser.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class Parser {
    
//    var stringValue = "5F201A54444320424C41434B20554E4C494D49544544205649534120204F07A00000000310105F24032307319F160F4243544553542031323334353637389F21031826509A031406179F02060000000000019F03060000000000009F34030203009F120C56495341204352454449544F9F0607A00000000310105F300202019F4E0F616263640000000000000000000000C408491573FFFFFF1097C00A09117101800165E0000AC2820168D9DE289AAD770BE408F6B1D4E0A2576CEA7F03CD479CE3A1827375D6C4D4959ACDB5D3B6F84CD83430F4346C35E48A77A0D5F36FBEA444C2D8701C07FFC7AF06C0485D68F7A83FC30840D3C0766EC4EE669BE5A42BAD4C7459680FAAAE9C4EFEFFEB5A590E53B3E91B3CD28A415C2C9484E26DA5A15592BBCD1F45CF49D27A9D480B031957DF8C790C55FF60DB192CCD070FA4F7BCDC99E7F7567C2F991B5536F9336BA66D68115D54BC3642A9CA47FDD162FCDC33E455AAC283975DACC98CBE9A6611E996F0740072CF8E32D3D9F39F4BB25568F5CC3E7F5DE158E4D62BF4E7185CF13BD068C4F062C26A3BBF88E056F249130E89AA29E52A1EBB6BAD98296822F10949F0C825D1449DA7EF4431AB846D0DDB916F2901359DD9A3B3395BAC9F9BE4D24657F65B030DDADA53577A14D9F5F776B6FF7EAB99D8C4BB08BEF2016C72D94B1DB91BCF0238405B7857646DCE5F79871D96B6A6652090FD8CFCC59973433919A6D0533DFE"
    
    
    
//    func hexToInt(hex: String) -> Int {
//        guard let num = Int(hex, radix: 16) else { return 0}
//        return num
//    }
//
//    func hexToString(hex: String) -> String? {
//        guard hex.count % 2 == 0 else {
//            return nil
//        }
//
//        var bytes = [CChar]()
//
//        var startIndex = hex.index(hex.startIndex, offsetBy: 2)
//        while startIndex < hex.endIndex {
//            let endIndex = hex.index(startIndex, offsetBy: 2)
//            let substr = hex[startIndex..<endIndex]
//
//            if let byte = Int8(substr, radix: 16) {
//                bytes.append(byte)
//            } else {
//                return nil
//            }
//
//            startIndex = endIndex
//        }
//
//        bytes.append(0)
//        return String(cString: bytes)
//    }
//    func parse(emvData: String) -> [TransactionDetail] {
    
//    var tag = Tag()
//    var converter = Converter()
    
    class func parseTransactions(tlvString: String, startIndex: Int = 0 ,startingLength: Int = 0) -> [TransactionDetail]  {
        var transactions: [TransactionDetail] = []
        //let end = Int(tlvString.suffix(8))
//        let end = (tlvString.count) - 4
        //will call succ 2 times
        //let end: Character = tlvString[index2]
        
//        if startIndex <= end {
        let firstTag = tlvString.rangeOf(r: Range(startIndex...(startIndex + 1)))
        
        let secondTag = tlvString.rangeOf(r: Range(startIndex...(startIndex + 3)))
        
        // Get tag
//        let tagName = getTagName(tag: firstTag) ?? getTagName(tag: secondTag)
        var tagName = Tag.getTagName(tag: firstTag) ?? Tag.getTagName(tag: secondTag)
        let actualTag = Tag.getTagName(tag: firstTag) != nil ? firstTag : secondTag
        
        if tagName != nil {
//        var twocharacterTag = tag.getTagName(tag: firstTag)
//        var fourCharacterTag = tag.getTagName(tag: secondTag)
        
//        var actualTag = tag.getTagName(tag: firstTag) != nil ? firstTag : secondTag
        
        // Have the model handle unknown
//        guard let _ = tagName else { print("I had to break out becuase I couldn't find a tag") }
        
        // Get length
        let lengthStart = actualTag.count + startingLength
        
        let lengthEnd = (actualTag.count + 1) + startingLength
        
        let hexLength = tlvString.rangeOf(r: Range(lengthStart...lengthEnd))
        
        //let length = hexToInt(hex: hexLength)
        let length = Converter.hexToInt(hex: hexLength)
        
        // Get value
        let value = tlvString.rangeOf(r: Range((lengthStart)...(length * 2) + lengthEnd))
        
//        let stringValue = hexToString(hex: value)
//        let intValue = hexToInt(hex: value)
        let stringValue = Converter.hexToString(hex: value)
        let intValue = Converter.hexToInt(hex: value)
        
        if intValue == 0 {
            //transactions.append(stringValue!)
           let td = TransactionDetail(name: tagName!, tagDetail:actualTag, value: stringValue!)
            transactions.append(td)
        } else {
            let numberString = String(intValue, radix: 16)
            let formattedNumberString = numberString.dropFirst(1)
            
            //transactions.append(String(formattedNumberString).uppercased())
            let td = TransactionDetail(name: tagName!, tagDetail:actualTag, value:formattedNumberString.uppercased())
            transactions.append(td)
        }
        
        print(transactions.last)
        //print(idk.last)
        // Manage recursion
        // Total count for this transaction, and where the next transaction starts
        let endOfTransaction = (length * 2 + (lengthEnd + 1))
        if endOfTransaction != tlvString.count - 4 {
            parseTransactions(tlvString: tlvString, startIndex: endOfTransaction, startingLength: endOfTransaction)
        }
        }
        return transactions
        }
    //}
}

//func completeWithTrans(completion: @escaping (_:[TransactionDetail]) -> Void) {
//    var idk = [TransactionDetail]()
//    
//}

extension String {
    
    func rangeOf(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        //print("The indexStart is \(start)")
        let end = index(startIndex, offsetBy: r.upperBound)
        //print("The indexEnd is \(end)")
        return String(self[Range(start ..< end)])
    }
}

