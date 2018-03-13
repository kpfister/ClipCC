//
//  Length.swift
//  Clip
//
//  Created by Karl Pfister on 3/8/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class Length {
    
    func isValid(byte: Int) -> Bool {
        if (byte != 0x80 && byte >= 0x00  && byte <= 0x84) {
            return true
        } else {
            return false
        }
    }
    
    func getLegnth(byte: Int) -> Int {
        return byte & 0x7f
    }
    
    func isMultiByte(byte: Int) -> Bool {
        return 0x01 == (byte >> 7)
    }
}


/*
 +(BOOL)isValid:(int)byte
 {
 if (byte != 0x80 && byte >= 0x00 && byte <= 0x84) {
 return YES;
 }
 
 return NO;
 }
 
 +(int)getLength:(int)byte
 {
 return byte & 0x7f;
 }
 
 +(BOOL)isMultiByte:(int)byte
 {
 return 0x01 == (byte >> 7);
 }
 */
