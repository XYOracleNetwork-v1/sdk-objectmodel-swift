//
//  XyoByteUtil.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

struct XyoByteUtil {
    static func concatAll(arrays : [[UInt8]]) -> [UInt8] {
        var masterBuffer = [UInt8]()
        
        for array in arrays {
            masterBuffer.append(contentsOf: array)
        }
        
        return masterBuffer
    }
}
