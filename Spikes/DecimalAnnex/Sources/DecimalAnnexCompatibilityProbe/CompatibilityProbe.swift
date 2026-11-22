// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import DecimalAnnexIntegration
import DecimalCore
import NumericsExtended

@main
internal enum CompatibilityProbe {
    internal static func main() throws {
        if #available(anyAppleOS 26.0, *) {
            let result: Decimal128 = try sum([Decimal128(1) / 10, Decimal128(2) / 10])
            print("Decimal128: \(result)")
        } else {
            print("Existing numeric functionality: \(try sum([Double(1), Double(2)]))")
        }
    }

    private static func sum<Value>(_ values: Array<Value>) throws -> Value
    where Value: Addable & RepresentableByZero, Value.Addend == Value, Value.Sum == Value {
        var result: Value = .zero
        for value in values {
            result = try result.adding(value)
        }
        return result
    }
}
