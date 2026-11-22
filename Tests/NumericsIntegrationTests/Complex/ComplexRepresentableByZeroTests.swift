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

@Suite("Complex RepresentableByZero Tests")
internal struct ComplexRepresentableByZeroTests {
    internal init() {}

    @Test("Zero is available through the protocol")
    internal func zero() {
        let result: Complex<Double> = Self.genericZero()
        #expect(result == Complex<Double>(0, 0))
    }

    private static func genericZero<Value>() -> Value
    where Value: RepresentableByZero {
        return .zero
    }
}
