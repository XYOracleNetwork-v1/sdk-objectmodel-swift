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
    
    func getNewIterator () throws -> XyoObjectIterator {
        return try XyoObjectIterator(currentOffset : readOwnHeader(), structure : self, isTyped : globalSchema != nil)
    }
    
    func getCount () throws -> Int {
        let sizeIt = try self.getNewIterator()
        var i = 0
        
        while (sizeIt.hasNext()) {
            i += 1
            try sizeIt.next()
        }
        
        return i
    }
    
    func get (index : Int) throws -> XyoObjectStructure {
        let it = try getNewIterator()
        var i = 0
        
        while (it.hasNext()) {
            let item = try it.next()
            
            if (index == i) {
                return item
            }
            
            i += 1
        }
        
        throw XyoObjectError.OUT_OF_INDEX
    }
    
    func get (id : UInt8) throws -> [XyoObjectStructure] {
        let it = try getNewIterator()
        var itemsThatFollowId = [XyoObjectStructure]()
        
        while (it.hasNext()) {
            let item = try it.next()
            
            if (item.getSchema().id == id) {
                itemsThatFollowId.append(item)
            }
            
        }
        
       return itemsThatFollowId
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
        
        let object = XyoBuffer(data: value, allowedOffset: offset, lastOffset: sizeOfObject + offset + schemaOfItem.getSizeIdentifier().rawValue + 1)
        
        if (schemaOfItem.getIsIterable()) {
            return XyoIterableStructure(value: object)
        }
        
        return XyoIterableStructure(value: object)
    }
    
    private func readItemTyped (offset : Int, schemaOfItem : XyoObjectSchema) throws -> XyoObjectStructure {
        let sizeOfObject = readSizeOfObject(sizeIdentifier : schemaOfItem.getSizeIdentifier(), offset: offset)
        
        if (sizeOfObject == 0) {
            throw XyoObjectError.SIZE_ZERO
        }
        
        let object = XyoBuffer(data: value, allowedOffset: offset, lastOffset: sizeOfObject + offset + schemaOfItem.getSizeIdentifier().rawValue - 1)
        
        if (schemaOfItem.getIsIterable()) {
            return XyoIterableStructure(value: object, schema: schemaOfItem)
        }
        
        return XyoObjectStructure(value: object, schema: schemaOfItem)
    }
    
    private func readOwnHeader () throws -> Int {
        let setHeader = value.getSchema(offset: 0)
        let totalSize = readSizeOfObject(sizeIdentifier: setHeader.getSizeIdentifier(), offset: 2)
        
        if (!setHeader.getIsIterable()) {
            throw XyoObjectError.NOT_ITERABLE
        }
        
        if (setHeader.getIsTypedIterable() && totalSize != setHeader.getSizeIdentifier().rawValue) {
            globalSchema = value.getSchema(offset: setHeader.getSizeIdentifier().rawValue + 2)
            return 4 + setHeader.getSizeIdentifier().rawValue
        }
        
        return 2 + setHeader.getSizeIdentifier().rawValue
    }
    
    class XyoObjectIterator {
        private var isTyped : Bool
        private var structure : XyoIterableStructure
        private var currentOffset : Int = 0
        
        init(currentOffset : Int, structure : XyoIterableStructure, isTyped : Bool) {
            self.structure = structure
            self.currentOffset = currentOffset
            self.isTyped = isTyped
        }
        
        func hasNext () -> Bool {
            return structure.value.getSize() + structure.value.allowedOffset > currentOffset
        }
        
        @discardableResult
        func next () throws -> XyoObjectStructure {
            
            let nextItem = try structure.readItemAtOffset(offset: currentOffset)
            
            if (isTyped) {
                currentOffset += nextItem.value.getSize() - 2
            } else {
                currentOffset += nextItem.value.getSize()
            }
            
            return nextItem
        }
    }
    
    static func createUntypedIterableObject (schema : XyoObjectSchema, values: [XyoObjectStructure]) throws -> XyoIterableStructure {
        if (schema.getIsTypedIterable()) {
            throw XyoObjectError.NOT_UNTYPED
        }
        
        let buffer = XyoBuffer()
        
        for item in values {
            buffer.put(buffer: item.getBuffer())
        }
        
        return XyoIterableStructure(value: XyoObjectStructure.newInstance(schema: schema, bytes: buffer).getBuffer())
    }
    
    static func createTypedIterableObject (schema : XyoObjectSchema, values: [XyoObjectStructure]) throws -> XyoIterableStructure {
        if (!schema.getIsTypedIterable()) {
            throw XyoObjectError.NOT_TYPED
        }
        
        if (values.isEmpty) {
            throw XyoObjectError.NO_ELEMENTS
        }
        
        let buffer = XyoBuffer()
        
        buffer.put(schema: values[0].getSchema())
        
        for item in values {
            buffer.put(buffer: item.value.copyRangeOf(from: 2, to: item.value.getSize()))
        }
        
        return XyoIterableStructure(value: XyoObjectStructure.newInstance(schema: schema, bytes: buffer).getBuffer())
    }
    
}
