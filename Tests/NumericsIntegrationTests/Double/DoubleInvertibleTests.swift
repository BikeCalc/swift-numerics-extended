// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Numerics
import NumericsExtended
import Testing

@Suite("Double Invertible Tests")
internal struct DoubleInvertibleTests {
    internal init() {}

    @Test(
        "Reciprocal",
        arguments: [
            (2, 0.5),
            (-2, -0.5)
        ] as Array<(Double, Double)>
    )
    internal func reciprocal(
        value: Double,
        expected: Double
    ) {
        #expect(Self.genericReciprocal(value) == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            (2, true), (-2, true),
            (.zero, true),
            (.infinity, true),
            (.greatestFiniteMagnitude, false)
        ] as Array<(Double, Bool)>
    )
    internal func isInvertible(
        value: Double,
        expected: Bool
    ) {
        #expect(Self.genericIsInvertible(value) == expected)
    }

    private static func genericReciprocal<Value>(_ value: Value) -> Value.Reciprocal?
    where Value: Invertible {
        return value.reciprocal
    }

    private static func genericIsInvertible<Value>(_ value: Value) -> Bool
    where Value: Invertible {
        return value.isInvertible
    }
}
