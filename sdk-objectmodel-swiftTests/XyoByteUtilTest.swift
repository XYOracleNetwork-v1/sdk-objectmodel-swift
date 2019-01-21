//
//  XyoByteUtilTest.swift
//  sdk-objectmodel-swiftTests
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import XCTest
@testable import sdk_objectmodel_swift

class XyoByteUtiltest : XCTestCase {
    
    func testConcatAll () {
        let expectedArray : [UInt8] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09]
        let arrayOne : [UInt8] = [0x00, 0x01, 0x02, 0x03]
        let arrayTwo : [UInt8] = [0x04, 0x05, 0x06]
        let arrayThree : [UInt8] = [0x07, 0x08, 0x09]
        
        let totalArray : [[UInt8]] = [arrayOne, arrayTwo, arrayThree]
        
    
        XCTAssertEqual(XyoByteUtil.concatAll(arrays: totalArray), expectedArray)
    }
    
}
