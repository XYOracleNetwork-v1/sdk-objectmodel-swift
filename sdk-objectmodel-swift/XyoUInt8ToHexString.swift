//
//  XyoUInt8ToHexString.swift
//  sdk-objectmodel-swift
//
//  Created by Carter Harrison on 1/21/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

public extension Collection where Element == UInt8 {
    public func toHexString () -> String {
        return "0x" + map{ String(format: "%02X", $0) }.joined()
    }
}
