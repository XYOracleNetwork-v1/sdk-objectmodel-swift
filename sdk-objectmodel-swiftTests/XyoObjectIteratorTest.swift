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
    
    func testObjectIteratorUntyped () throws {
        let iterableStructure = XyoIterableStructure(value: XyoBuffer(data: [0x20, 0x41, 0x09, 0x00, 0x44, 0x02, 0x14, 0x00, 0x42, 0x02, 0x37]))
        let iterable = try iterableStructure.getNewIterator()
        var i = 0
        
        while try iterable.hasNext() {
            if (i == 0) {
                let bytes = try iterable.next().getBuffer().toByteArray()
                XCTAssertEqual(bytes, [0x00, 0x44, 0x02, 0x14])
            } else if (i == 1) {
                let bytes = try iterable.next().getBuffer().toByteArray()
                XCTAssertEqual(bytes, [0x00, 0x42, 0x02, 0x37])
            } else {
                throw XyoObjectError.OUT_OF_INDEX
            }
            
            i += 1
        }
    }
    
    func testObjectIteratorTyped () throws {
        let iterableStructure = XyoIterableStructure(value: XyoBuffer(data: [0x30, 0x41, 0x07, 0x00, 0x44, 0x02, 0x13, 0x02, 0x37]))
        let iterable = try iterableStructure.getNewIterator()
        var i = 0
        
        while try iterable.hasNext() {
            if (i == 0) {
                let bytes = try iterable.next().getBuffer().toByteArray()
                XCTAssertEqual(bytes, [0x00, 0x44, 0x02, 0x13])
            } else if (i == 1) {
                let bytes = try iterable.next().getBuffer().toByteArray()
                XCTAssertEqual(bytes, [0x00, 0x44, 0x02, 0x37])
            } else {
                throw XyoObjectError.OUT_OF_INDEX
            }
            
            i += 1
        }
    }
    
    func testValidateTrue () throws {
        let rawBytes = "600201A22015CB2019C8000C41170F9302323929FD3FD8A72851F73866A0BFC6D488040E9D921689E01B9E25E4393B0984576763DD9C5DA95E609A80B4CC12064758C1AEEE28AE264015BF474F000D8200AEB335766EC511499DDE566579B4ED1562079AA543388B2EDED68ED68363AE9DAE25E7E29B9A5607E676A5F50CC6EB5CBCEBDEE30FB3F1CB9DA0074D4D3CA29B8BFD42AEEE44CA7C26134F4401FF67332C549AD72B36FBF9211D07B0B825C137D6A0DD13EE35FE446B55D22E66CE751216DC4BB823A3A62C3D0208CAC0DF68AB2017D1201ACA00094421009A0FF234B98891EE3FF99365A3CA6AB804173F1A8619934134A68F59FBDCA92E200C04A196D4A39C987C984E18B79D3EE81667DD92E962E6C630DB5D7BDCDB1988000A81713AB83E5D8B4EF6D2EAB4D70B61AADCA01E733CB0B3D072DE307CDBCD09F46D528A7159EB73DEBB018871E30D182F5BBB426689E758A7BFD4C51D0AD116CA621BF1C39DA49A837D525905D22BAB7C1874F6C7E6B4D56139A15C3BE1D1DC8E061C241C060A24B588217E37D6206AFE5D71F4698D42E25C4FCE996EECCF7690B900130200".hexStringToBytes()
        
        let structuer = XyoIterableStructure(value: XyoBuffer(data: rawBytes))
        try XyoIterableStructure.verify(item: structuer)
    }
    
    func testValidateFalse () throws {
        let rawBytes = "600201A22015CB2019C8000C41170F9302323929FD3FD8A72851F73866A0BFC6D488040E9D921689E01B9E25E4393B0984576763DD9C5DA95E609A80B4CC12064758C1AEEE28AE264015BF474F000D8200AEB335766EC511499DDE566579B4ED1562079AA543388B2EDED68ED68363AE9DAE25E7E29B9A5607E670FF234B98891EE3FF99365A3CA6AB804173F1A8619934134A68F59FBDCA92E200C04A196D4A39C987C984E18B79D3EE81667DD92E962E6C630DB5D7BDCDB1988000A81713AB83E5D8B4EF6D2EAB4D70B61AADCA01E733CB0B3D072DE307CDBCD09F46D528A7159EB73DEBB018871E30D182F5BBB426689E758A7BFD4C51D0AD116CA621BF1C39DA49A837D525905D22BAB7C1874F6C7E6B4D56139A15C3BE1D1DC8E061C241C060A24B588217E37D6206AFE5D71F4698D42E25C4FCE996EECCF7690B900130200".hexStringToBytes()
        
        let structuer = XyoIterableStructure(value: XyoBuffer(data: rawBytes))
        
        do {
            try XyoIterableStructure.verify(item: structuer)
        } catch is XyoObjectError {
            return
            // this is expected
        }
        
        throw XyoObjectError.OUT_OF_INDEX
    }
    
}
