//
//  XyoObjectStructure.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

class XyoObjectStructure {
    let schema : XyoObjectSchema
    var value = [UInt8]()
    
    init (schema : XyoObjectSchema) {
        self.schema = schema
    }
    
    func getBuffer () -> XyoBuffer {
        let buffer = XyoBuffer()
        let size = value.count + schema.getSizeIdentifier().rawValue
        let typeOfSize = XyoByteUtil.getBestSize(size : size)
        buffer.put(schema : schema)
        
        switch (typeOfSize) {
        case XyoObjectSize.ONE:
            buffer.put(bits : UInt8(size))
        case XyoObjectSize.TWO:
            buffer.put(bits : UInt16(size))
        case XyoObjectSize.FOUR:
            buffer.put(bits : UInt32(size))
        case XyoObjectSize.EIGHT:
            buffer.put(bits : UInt64(size))
        }
        
        buffer.put(bytes: value)
        return buffer
    }
    
    func getBytes() -> [UInt8] {
        return getBuffer().toByteArray()
    }
}
