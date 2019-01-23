//
//  XyoObjectStructureTest.swift
//  sdk-objectmodel-swiftTests
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import XCTest
@testable import sdk_objectmodel_swift

class XyoObjectStructureTest : XCTestCase {
    
    func testGetBuffer () {
        let schema = XyoObjectSchema.create(id: 0xff, isIterable: false, isTypedIterable: false, sizeIdentifier: XyoObjectSize.ONE)
        let structure = XyoObjectStructure.newInstance(schema: schema, bytes: XyoBuffer(data: [0x13, 0x37]))
        
        XCTAssertEqual(structure.getBuffer().toByteArray(), [0x00, 0xff, 0x03, 0x13, 0x37])
    }
    
    func testGetValue () {
        let schema = XyoObjectSchema.create(id: 0xff, isIterable: false, isTypedIterable: false, sizeIdentifier: XyoObjectSize.ONE)
        let structure = XyoObjectStructure.newInstance(schema: schema, bytes: XyoBuffer(data: [0x13, 0x37]))
        
        XCTAssertEqual(structure.getValueCopy().toByteArray(), [0x13, 0x37])
    }
    
}
