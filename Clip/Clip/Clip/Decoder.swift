//
//  Decoder.swift
//  Clip
//
//  Created by Karl Pfister on 3/8/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class Decoder {
    let classTag = Tag()
    let classLength = Length()
    
    func decodeWithString(hex : String) -> NSDictionary {
        
        guard hex.count % 2 == 0 else {
            return [:]
        }
        /*let startIndex = str.index(str.startIndex, offsetBy: 0)
         let endIndex = str.index(str.startIndex, offsetBy: 2)
         
         
         String(str[startIndex...endIndex])

         */
        var stringLegnth = hex.count % 2
        var currentLocation = 0
        
        var bytes: NSMutableArray = NSMutableArray(capacity: stringLegnth)
        
        for character in hex.characters {
            
            let object = hexToInt(hex: String(character))
            currentLocation += 2
            bytes.add(object)
        }
        return decodeTLV(bytes: bytes)
    }
        
//        var bytes = [CChar]()
//
//        var startIndex = hex.index(hex.startIndex, offsetBy: 2)
//        while startIndex < hex.endIndex {
//            let endIndex = hex.index(startIndex, offsetBy: 2)
//            let substr = hex[startIndex..<endIndex]
//
//             let byte = Int8(substr, radix: 16)
//            bytes.append(byte!)
//
//            startIndex = endIndex
//        }
//
//        bytes.append(0)
//        let dict = decodeTLV(bytes: bytes as NSArray)
//
//        return dict
//    }
    
//        if (TLV.count % 2 != 0) {
//            print("Invalid TLV String")
//        }
//         var bytes = [CChar]()
//        var startIndex = TLV.index(TLV.startIndex, offsetBy: 2)
//        while startIndex < TLV.endIndex {
//            let endIndex = TLV.index(startIndex, offsetBy: 2)
//            let substr = TLV[startIndex..<endIndex]
//
//            if let byte = Int8(substr, radix: 16) {
//                bytes.append(byte)
//            } else {
//                return [:]
//            }
//
//            startIndex = endIndex
//        }
//
//        bytes.append(0)
//        return decodeTLV(bytes: bytes as NSArray)
        
    
    
    
    /*
     guard hex.characters.count % 2 == 0 else {
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
     */
    
    
    func decodeTLV(bytes: NSArray) -> NSDictionary {
        
        let tag: NSMutableArray = []
        let tree: NSMutableDictionary = [:]
        
        var curser = 0
        let extent = bytes.count
        
        var tagIsContructed = true
        
        var actualLength = 0
        var actualTag = ""
        var actualVal = ""
        
        while curser < extent {
            actualLength = 0
            actualTag = ""
            actualVal = ""
            
            
            if bytes.count <= curser {
                break
            }
            tag.add(bytes[curser])
            
            var firstTag = tag.firstObject as! Int
            
            if self.classTag.isValid(byte: firstTag) {
                curser += 1
                
            }
            
            tagIsContructed = classTag.isConstructed(byte: firstTag)
            if classTag.isMultiByte(byte: firstTag) {
                curser += 1
                
                if bytes.count <= curser {
                    break
                }
                tag.add(bytes[curser])
                
                var currentByte = bytes[curser] as! Int
                
                if classTag.isLast(byte: currentByte) {
                    curser += 1
                    
                    if bytes.count <= curser {
                        break
                    }
                    tag.add(bytes[curser])
                }
            }
            
            var fullTag = ""
            for num in tag {
                var hexString =  String(format: "%021x")
                fullTag = fullTag.appending(hexString)
                
            }
            actualTag = fullTag
            tag.removeAllObjects()
            curser += 1
            
            /// Length
            
            if bytes.count <= curser {
                break
            }
           
            let length = bytes[curser]
            let intLength = length as! Int
            
            if classLength.isValid(byte: intLength) == false {
                break
            }
            
            var myLegnth = classLength.getLegnth(byte: intLength)
            actualLength = myLegnth
            
            if classLength.isMultiByte(byte: intLength) {
                var lengthCursor = 0
                var lengthExtent = myLegnth
                
                var tagLenght: NSMutableArray = []
                
                while lengthCursor < lengthExtent {
                    curser += 1
                    if bytes.count <= curser {
                        break
                    }
                    var byteCurs = bytes[curser] as? Int
                    var temp = byteCurs! << (((lengthExtent - lengthCursor) - 1) * 8)
                    tagLenght.add(temp)
                    
                    lengthCursor += 1
                    
                }
                
                if bytes.count <= curser {
                    break
                }
                
                var lengthOutput = 0
                for num in tagLenght {
                    lengthOutput = lengthOutput | (num as AnyObject).intValue
                }
                actualLength = lengthOutput
                
            }
            curser += 1
            
            // Value
            
            if bytes.count <= curser {
                break
            }
            var range = NSMakeRange(curser, actualLength)
            var value = bytes.subarray(with: range)
            
            var newVal: NSDictionary = [:]
            
            if tagIsContructed {
                newVal = decodeTLV(bytes: value as NSArray)
            } else {
                var fullVal = ""
                
                for num in value {
                    var hexString =  String(format: "%021x")
                    fullVal = fullVal.appending(hexString)
                    
                }
                actualVal = fullVal
            }
            curser += actualLength
            
            tree[actualTag] = ["name": classTag.getTagName(tag: actualTag),
                               "length": actualLength,
            "value": actualVal]
            
        }
       
     return tree
        print(tree)
    }
    
    func hexToString(hex: String) -> String? {
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
    
    func hexToInt(hex: String) -> Int {
        var result = Int(hex, radix: 16)
        return result!
        //result = (hex, nil, 16)
}
    
    
    
    
}

/*
 + (NSDictionary*)decodeWithString:(NSString*)tlv
 {
 if(tlv.length %2 !=0)
 {
 NSLog(@"Invalid TLV");
 return nil;
 }
 
 int length = tlv.length/2;
 int currentLoc = 0;
 
 NSMutableArray *bytes = [[NSMutableArray alloc] initWithCapacity:length];
 for (int i =0; i < length; i++) {
 NSString *byte = [tlv substringWithRange:NSMakeRange(currentLoc, 2)];
 currentLoc +=2;
 [bytes addObject:@([SGTLVDecode hexToInt:byte])];
 }
 
 return [SGTLVDecode decodeTlv:bytes];
 }
 */
