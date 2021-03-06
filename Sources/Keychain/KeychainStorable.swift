//
//  KeychainStorable.swift
//  Keychain
//
//  Created by Rauhul Varma on 3/3/17.
//  Copyright © 2020 rauhul. All rights reserved.
//

import Foundation

/// DataConvertible defines a protocol a type must satisfy in order to be used in a Keychain operation; ie Stored, Retrieved, etc...
public protocol DataConvertible {
    /// Converts Data retrieved from the Keychain into a KeychainStorable Type
    init?(data: Data)

    /// Converts a KeychainStorable Type into Data to be stored in the Keychain
    var data: Data { get }
}

/// SimpleStruct is a marker protocol used to provide DataConvertible conformance to any simple value type.
public protocol SimpleStruct { }

extension DataConvertible where Self: SimpleStruct {
    public init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }

    public var data: Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

/// Extend Bool to be DataConvertible
extension Bool: SimpleStruct, DataConvertible { }

/// Extend Int to be DataConvertible
extension Int: SimpleStruct, DataConvertible {}

/// Extend Float to be DataConvertible
extension Float: SimpleStruct, DataConvertible {}

/// Extend Double to be DataConvertible
extension Double: SimpleStruct, DataConvertible { }

/// Extend String to be DataConvertible
extension String: DataConvertible {
    public init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }

    public var data: Data {
        return data(using: .utf8) ?? Data()
    }
}

/// Extend Data to be DataConvertible
extension Data: DataConvertible {
    public init?(data: Data) {
        self = data
    }

    public var data: Data {
        return self
    }
}
