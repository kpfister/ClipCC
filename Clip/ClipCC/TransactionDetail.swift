//
//  Transaction.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import Foundation

class TransactionDetail {
    
    var tagDetail: String
    var tag: String
    var value: String
    
    init(tag: String, tagDetail: String, value: String) {
        self.tag = tag
        self.tagDetail = tagDetail
        self.value = value
        
    }
}


