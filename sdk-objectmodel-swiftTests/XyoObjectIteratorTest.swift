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
        
        let expectedIterable : [UInt8] = [0x20, 0xff,
                                0x0b,
                                0x00, 0x55,
                                0x03,
                                0x13, 0x37,
                                0x00, 0x55,
                                0x03,
                                0x13, 0x37]
        
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
        
        let expectedIterable : [UInt8] = [0x30, 0xff,
                                          0x07,
                                          0x03,
                                          0x13, 0x37,
                                          0x03,
                                          0x13, 0x37]
        
        let createdSet = try XyoIterableStructure.createTypedIterableObject(schema: iterableSchema, values: values)
        
        XCTAssertEqual(createdSet.value.toByteArray(), expectedIterable)
    }
    
}
