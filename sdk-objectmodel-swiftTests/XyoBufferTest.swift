//
//  XyoBufferTest.swift
//  sdk-objectmodel-swiftTests
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import XCTest
@testable import sdk_objectmodel_swift

class XyoBufferTest : XCTestCase {
    
    func testPutSchema () {
        let buffer = XyoBuffer()
        let schema = XyoObjectSchema(id: 0x13, encodingCatalogue: 0x37)
        buffer.put(schema: schema)
        
        XCTAssertEqual(buffer.toByteArray(), schema.toByteArray())
    }
    
    func testPutBytes () {
        let buffer = XyoBuffer()
        let bytes : [UInt8] = [0x13, 0x37]
        buffer.put(bytes: bytes)
        
        XCTAssertEqual(buffer.toByteArray(), bytes)
    }
    
    func testPutUInt8 () {
        let buffer = XyoBuffer()
        let byte : UInt8 = 0xff
        buffer.put(bits: byte)
        
        XCTAssertEqual(buffer.toByteArray(), [byte])
    }
    
    func testPutUInt16() {
        let buffer = XyoBuffer()
        let int : UInt16 = 0x05
        buffer.put(bits : int)
        
        XCTAssertEqual(buffer.toByteArray(), [0x00, 0x05])
    }
    
    func testPutUInt32() {
        let buffer = XyoBuffer()
        let int : UInt32 = 0x05
        buffer.put(bits : int)
        
        XCTAssertEqual(buffer.toByteArray(), [0x00, 0x00, 0x00, 0x05])
    }
    
    func testPutUInt64() {
        let buffer = XyoBuffer()
        let int : UInt64 = 0x05
        buffer.put(bits : int)
        
        XCTAssertEqual(buffer.toByteArray(), [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05])
    }
    
    func testGetSchema () {
        let schema = XyoObjectSchema(id: 0x13, encodingCatalogue: 0x37)
        let buffer = XyoBuffer(data : schema.toByteArray())
        let got = buffer.getSchema(offset: 0)
        
        XCTAssertEqual(got.toByteArray(), schema.toByteArray())
    }
    
    func testGetUInt8 () {
        let int : UInt8 = 0x15
        let buffer = XyoBuffer(data : [int])
        let got = buffer.getUInt8(offset: 0)
        
        XCTAssertEqual(got, int)
    }
    
    func testGetUInt16 () {
        let int : UInt16 = 0x05
        let buffer = XyoBuffer(data : [0x00, 0x05])
        let got = buffer.getUInt16(offset: 0)
        
        XCTAssertEqual(got, int)
    }
    
    func testGetUInt32 () {
        let int : UInt32 = 0x05
        let buffer = XyoBuffer(data : [0x00, 0x00, 0x00, 0x05])
        let got = buffer.getUInt32(offset: 0)
        
        XCTAssertEqual(got, int)
    }
    
    func testGetUInt64 () {
        let int : UInt64 = 0x05
        let buffer = XyoBuffer(data : [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05])
        let got = buffer.getUInt64(offset: 0)
        
        XCTAssertEqual(got, int)
    }
    
}
