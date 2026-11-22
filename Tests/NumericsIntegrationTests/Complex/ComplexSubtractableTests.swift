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

@Suite("Complex Subtractable Tests")
internal struct ComplexSubtractableTests {
    internal init() {}

    private static let subtractionArguments: Array<(Complex<Double>, Complex<Double>, Complex<Double>)> = [
        (.init(3, 5), .init(2, 3), .init(1, 2)),
        (.init(-3, -5), .init(2, -3), .init(-5, -2)),
        (.init(1.5, 3.5), .init(0.5, 1.5), .init(1, 2)),
        (.init(-1.5, -3.5), .init(0.5, -1.5), .init(-2, -2))
    ]

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: Complex<Double>,
        subtrahend: Complex<Double>,
        difference: Complex<Double>
    ) throws {
        let result: Complex<Double> = try minuend.subtracting(subtrahend)
        #expect(result == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: Complex<Double>,
        subtrahend: Complex<Double>,
        difference: Complex<Double>
    ) throws {
        var result: Complex<Double> = minuend
        try result.subtract(subtrahend)
        #expect(result == difference)
    }
}
