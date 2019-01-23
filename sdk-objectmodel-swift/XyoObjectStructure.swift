//
//  XyoObjectStructure.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

open class XyoObjectStructure {
    private let typedSchema : XyoObjectSchema?
    let value : XyoBuffer
    
    public init (value : XyoBuffer) {
        self.typedSchema = nil
        self.value = value
    }
    
    public init (value : XyoBuffer, schema : XyoObjectSchema) {
        self.typedSchema = schema
        self.value = XyoBuffer().put(schema: schema).put(buffer: value)
    }
    
    public func getBuffer () -> XyoBuffer {
        return value
    }
    
    public func getSchema () -> XyoObjectSchema {
        return typedSchema ?? value.getSchema(offset: 0)
    }
    
    public func getValueCopy () -> XyoBuffer {
        let startIndex = value.allowedOffset + 2 + getSchema().getSizeIdentifier().rawValue
        let endIndex = startIndex + getSize()
        return XyoBuffer(data: value, allowedOffset: startIndex, lastOffset: endIndex)
    }
    
    public func getSize () -> Int {
        return readSizeOfObject(sizeIdentifier: getSchema().getSizeIdentifier(), offset: 2)
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

    public static func newInstance (schema: XyoObjectSchema, bytes : XyoBuffer) -> XyoObjectStructure {
        let buffer = XyoBuffer()
        let size = bytes.toByteArray().count
        let typeOfSize = XyoByteUtil.getBestSize(size : size)
        buffer.put(schema : XyoObjectSchema.create(id: schema.id, isIterable: schema.getIsIterable(), isTypedIterable: schema.getIsTypedIterable(), sizeIdentifier: typeOfSize))
        
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
