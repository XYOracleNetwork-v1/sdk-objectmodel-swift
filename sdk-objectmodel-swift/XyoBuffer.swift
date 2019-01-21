//
//  XyoBuffer.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

class XyoBuffer {
    private let readOnly : Bool
    private let allowedOffset : Int
    private var data : [UInt8]
    
    init(data : [UInt8], allowedOffset: Int, readOnly : Bool) {
        self.data = data
        self.allowedOffset = allowedOffset
        self.readOnly = readOnly
    }
    
    init(data : [UInt8]) {
        self.data = data
        self.allowedOffset = 0
        self.readOnly = false
    }
    
    init() {
        self.data = [UInt8]()
        self.allowedOffset = 0
        self.readOnly = false
    }
    
    private func getEnd () -> Int {
        return data.endIndex
    }
    
    func toByteArray() -> [UInt8] {
        return Array(data[allowedOffset..<data.count])
    }
    
    func getSchema() -> XyoObjectSchema {
        return getSchemaAtOffest(offset: allowedOffset)
    }
    
    func getSchemaAtOffest(offset : Int) -> XyoObjectSchema {
        return XyoObjectSchema(id: data[allowedOffset + offset], encodingCatalogue: data[allowedOffset + offset + 1])
    }
    
    func getUInt8 (offset : Int) -> UInt8 {
        return data[allowedOffset + offset]
    }
    
    func getUInt16 (offset : Int) -> UInt16 {
        let one = UInt16(data[allowedOffset + offset])
        let two = UInt16(data[allowedOffset + offset + 1])
        
        return (two << 8) + one
    }
    
    func getUInt32 (offset : Int) -> UInt32 {
        let one = UInt32(data[allowedOffset + offset])
        let two = UInt32(data[allowedOffset + offset + 1])
        let three = UInt32(data[allowedOffset + offset + 2])
        let four = UInt32(data[allowedOffset + offset + 3])
        
        return (four << 24) + (three << 16) + (two << 8) + one
    }
    
    func getUInt64 (offset : Int) -> UInt64 {
        let one = UInt64(data[allowedOffset + offset])
        let two = UInt64(data[allowedOffset + offset + 1]) << 8
        let three = UInt64(data[allowedOffset + offset + 2]) << 16
        let four = UInt64(data[allowedOffset + offset + 3]) << 24
        let five = UInt64(data[allowedOffset + offset + 4]) << 32
        let six = UInt64(data[allowedOffset + offset + 5]) << 40
        let seven = UInt64(data[allowedOffset + offset + 6]) << 48
        let eight = UInt64(data[allowedOffset + offset + 7]) << 56
        
        return (one+two+three+four)+(five+six+seven+eight)
    }
    

    @discardableResult
    func put(schema : XyoObjectSchema) -> XyoBuffer {
        let schemaBytes = schema.toByteArray()
        data[allowedOffset + getEnd()] = schemaBytes[0]
        data[allowedOffset + getEnd() + 1] = schemaBytes[1]
        return self
    }
    
    @discardableResult
    func put(bytes : [UInt8]) -> XyoBuffer {
        data.append(contentsOf: bytes)
        return self
    }
    
    @discardableResult
    func put(bits : UInt8) -> XyoBuffer {
        data.append(bits)
        return self
    }
    
    @discardableResult
    func put(bits : UInt16) -> XyoBuffer {
        data.append(UInt8(bits & 0xFF))
        data.append(UInt8((bits >> 8) & 0xFF))
        return self
    }
    
    @discardableResult
    func put(bits : UInt32) -> XyoBuffer {
        data.append(UInt8(bits & 0xFF))
        data.append(UInt8((bits >> 8) & 0xFF))
        data.append(UInt8((bits >> 16) & 0xFF))
        data.append(UInt8((bits >> 24) & 0xFF))
        return self
    }
    
    @discardableResult
    func put(bits : UInt64) -> XyoBuffer {
        data.append(UInt8(bits & 0xFF))
        data.append(UInt8((bits >> 8) & 0xFF))
        data.append(UInt8((bits >> 16) & 0xFF))
        data.append(UInt8((bits >> 24) & 0xFF))
        data.append(UInt8((bits >> 32) & 0xFF))
        data.append(UInt8((bits >> 40) & 0xFF))
        data.append(UInt8((bits >> 48) & 0xFF))
        data.append(UInt8((bits >> 56) & 0xFF))
        return self
    }
    
    @discardableResult
    func put (buffer : XyoBuffer) -> XyoBuffer {
        return put(bytes: buffer.toByteArray())
    }

    static func newStructure (schema : XyoObjectSchema, value : [UInt8]) -> XyoBuffer {
        let buffer = XyoBuffer()
        buffer.put(schema : schema)
        buffer.put(bits : UInt32(value.count + schema.getSizeIdentifier().rawValue))
        buffer.put(bytes: value)
        return buffer
    }
}
