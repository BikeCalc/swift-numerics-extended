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

@Suite("Complex Invertible Tests")
internal struct ComplexInvertibleTests {
    internal init() {}

    @Test(
        "Reciprocal",
        arguments: [
            (.init(1, 1), .init(0.5, -0.5)),
            (.init(-1, -1), .init(-0.5, 0.5))
        ] as Array<(Complex<Double>, Complex<Double>)>
    )
    internal func reciprocal(
        value: Complex<Double>,
        expected: Complex<Double>
    ) {
        #expect(Self.genericReciprocal(value) == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            (.init(1, 1), true), (.init(-1, -1), true),
            (.zero, true),
            (.infinity, true),
            (.init(.greatestFiniteMagnitude, 0), false)
        ] as Array<(Complex<Double>, Bool)>
    )
    internal func isInvertible(
        value: Complex<Double>,
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
