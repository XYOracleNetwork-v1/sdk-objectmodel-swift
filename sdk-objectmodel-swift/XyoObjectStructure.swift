//
//  XyoObjectStructure.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

class XyoObjectStructure {
    private let typedSchema : XyoObjectSchema?
    let value : XyoBuffer
    
    private var headerSize : Int {
        if (typedSchema == nil) {
            return 0
        }
        
        return 2
    }
    
    init (value : XyoBuffer) {
        self.typedSchema = nil
        self.value = value
    }
    
    init (value : XyoBuffer, schema : XyoObjectSchema) {
        self.typedSchema = schema
        self.value = value
    }
    
    open func getBuffer () -> XyoBuffer {
        return value
    }
    
    open func getSchema () -> XyoObjectSchema {
        return typedSchema ?? value.getSchema(offset: 0)
    }
    
    open func getValueCopy () -> XyoBuffer {
        let sizeOfObject = getSize()
        return XyoBuffer(data: value, allowedOffset: value.allowedOffset, lastOffset : sizeOfObject + value.allowedOffset + headerSize)
    }
    
    func getSize () -> Int {
        return readSizeOfObject(sizeIdentifier: getSchema().getSizeIdentifier(), offset: headerSize)
    }
    
    func readSizeOfObject (sizeIdentifier : XyoObjectSize, offset : Int) -> Int {
        switch sizeIdentifier {
        case XyoObjectSize.ONE:
            return Int(value.getUInt8(offset: offset))
        case XyoObjectSize.TWO:
            return Int(value.getUInt16(offset: offset))
        case XyoObjectSize.FOUR:
            return Int(value.getUInt32(offset: offset))
        case XyoObjectSize.EIGHT:
            return Int(value.getUInt64(offset: offset))
        }
    }

    static func newInstance (schema: XyoObjectSchema, bytes : XyoBuffer) -> XyoObjectStructure {
        let buffer = XyoBuffer()
        let size = bytes.toByteArray().count + schema.getSizeIdentifier().rawValue
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
        
        buffer.put(bytes: bytes.toByteArray())
        
        return XyoObjectStructure(value: buffer)
    }
}
