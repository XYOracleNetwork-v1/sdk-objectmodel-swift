//
//  XyoObjectIteratorTest.swift
//  sdk-objectmodel-swiftTests
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import XCTest
@testable import sdk_objectmodel_swift

class XyoObjectIteratorTest : XCTestCase {
    let itemOneSchema = XyoObjectSchema.create(id: 0x55,
                                                isIterable: false,
                                                isTypedIterable: false,
                                                sizeIdentifier: XyoObjectSize.ONE)
    
    let itemTwoSchema = XyoObjectSchema.create(id: 0x55,
                                                isIterable: false,
                                                isTypedIterable: false,
                                                sizeIdentifier: XyoObjectSize.ONE)
    
    func testCreateUntypedIterableObject () throws {
        let iterableSchema = XyoObjectSchema.create(id: 0xff,
                                            isIterable: true,
                                            isTypedIterable: false,
                                            sizeIdentifier: XyoObjectSize.ONE)
        
        let values : [XyoObjectStructure] = [
            XyoObjectStructure.newInstance(schema: itemOneSchema, bytes: XyoBuffer(data: [0x13, 0x37])),
            XyoObjectStructure.newInstance(schema: itemTwoSchema, bytes: XyoBuffer(data: [0x13, 0x37])),
        ]
        
        let expectedIterable : [UInt8] = [0x20, 0xff,   // root header
                                          0x0b,         // size of entire array
                                          0x00, 0x55,   // header of element [0]
                                          0x03,         // size of element [0]
                                          0x13, 0x37,   // value of element [0]
                                          0x00, 0x55,   // header of element [1]
                                          0x03,         // size of element [1]
                                          0x13, 0x37]   // value of element [1]
        
        let createdSet = try XyoIterableStructure.createUntypedIterableObject(schema: iterableSchema, values: values)
        
        XCTAssertEqual(createdSet.value.toByteArray(), expectedIterable)
    }
    
    func testCreateTypedIterableObject () throws {
        let iterableSchema = XyoObjectSchema.create(id: 0xff,
                                                    isIterable: true,
                                                    isTypedIterable: true,
                                                    sizeIdentifier: XyoObjectSize.ONE)
        
        let values : [XyoObjectStructure] = [
            XyoObjectStructure.newInstance(schema: itemOneSchema, bytes: XyoBuffer(data: [0x13, 0x37])),
            XyoObjectStructure.newInstance(schema: itemTwoSchema, bytes: XyoBuffer(data: [0x13, 0x37])),
        ]
        
        let expectedIterable : [UInt8] = [0x30, 0xff, // root header
                                          0x09,       // size of entire array
                                          0x00, 0x55, // header for all elements
                                          0x03,       // size of element [0]
                                          0x13, 0x37, // value of element [0]
                                          0x03,       // size of element [1]
                                          0x13, 0x37] // value of element [1]
        
        let createdSet = try XyoIterableStructure.createTypedIterableObject(schema: iterableSchema, values: values)
        
        XCTAssertEqual(createdSet.value.toByteArray(), expectedIterable)
    }
    
}
