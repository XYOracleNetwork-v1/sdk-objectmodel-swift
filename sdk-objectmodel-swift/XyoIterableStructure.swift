//
//  XyoIterableStructure.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

class XyoIterableStructure: XyoObjectStructure {
    private var globalSchema : XyoObjectSchema? = nil
    private var currentOffset : Int = 0
    
    func hasNext () -> Bool {
        return 2 + getSize() + value.allowedOffset > currentOffset
    }
    
    func next () throws -> XyoObjectStructure {
        let nextItem = try readItemAtOffset(offset: currentOffset)
        
        if (globalSchema == nil) {
            currentOffset += nextItem.getSize() + 2
        } else {
            currentOffset += nextItem.getSize()
        }
        
        return nextItem
    }
    
    func readItemAtOffset (offset : Int) throws -> XyoObjectStructure {
        if (globalSchema == nil) {
            return try readItemUntyped(offset: offset)
        }
        
        return try readItemTyped(offset: offset, schemaOfItem: globalSchema!)
    }
    
    private func readItemUntyped (offset : Int) throws -> XyoObjectStructure {
        let schemaOfItem =  value.getSchema(offset: offset)
        let sizeOfObject = readSizeOfObject(sizeIdentifier : schemaOfItem.getSizeIdentifier(), offset: offset + 2)
        
        if (sizeOfObject == 0) {
            throw XyoObjectError.SIZE_ZERO
        }
        
        if (schemaOfItem.getIsIterable()) {
            return XyoIterableStructure(value: XyoBuffer(data: value, allowedOffset: offset))
        }
        
        return XyoIterableStructure(value: XyoBuffer(data: value, allowedOffset: offset))
    }
    
    private func readItemTyped (offset : Int, schemaOfItem : XyoObjectSchema) throws -> XyoObjectStructure {
        let sizeOfObject = readSizeOfObject(sizeIdentifier : schemaOfItem.getSizeIdentifier(), offset: offset + 2)
        
        if (sizeOfObject == 0) {
            throw XyoObjectError.SIZE_ZERO
        }
        
        if (schemaOfItem.getIsIterable()) {
            return XyoIterableStructure(value: XyoBuffer(data: value, allowedOffset: offset), schema: schemaOfItem)
        }
        
        return XyoObjectStructure(value: XyoBuffer(data: value, allowedOffset: offset), schema: schemaOfItem)
    }
    
}
