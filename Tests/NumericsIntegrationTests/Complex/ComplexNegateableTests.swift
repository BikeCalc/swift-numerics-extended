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

@Suite("Complex Negateable Tests")
internal struct ComplexNegateableTests {
    internal init() {}

    private static let negationArguments: Array<(Complex<Double>, Complex<Double>)> = [
        (.init(1, 5), .init(-1, -5)),
        (.init(-1, -5), .init(1, 5)),
        (.init(0.5, 1.5), .init(-0.5, -1.5)),
        (.init(-0.5, -1.5), .init(0.5, 1.5))
    ]

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Complex<Double>,
        negation: Complex<Double>
    ) {
        let result: Complex<Double> = value.negating()
        #expect(result == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Complex<Double>,
        negation: Complex<Double>
    ) {
        var result: Complex<Double> = value
        result.negate()
        #expect(result == negation)
    }

    @Test(
        "Is signed",
        arguments: [
            .init(1, 5),
            .init(-1, -5),
            .init(0.5, 1.5),
            .init(-0.5, -1.5)
        ] as Array<Complex<Double>>
    )
    internal func isSigned(value: Complex<Double>) {
        #expect(value.isSigned == true)
    }

    @Test(
        "Is opposite",
        arguments: [
            (.init(1, 5), .init(1, 5), false),
            (.init(-1, -5), .init(1, 5), true),
            (.init(0.5, 1.5), .init(-0.5, -1.5), true),
            (.init(0.5, 1.5), .init(-0.5, 1.5), false)
        ] as Array<(Complex<Double>, Complex<Double>, Bool)>
    )
    internal func isOpposite(
        value: Complex<Double>,
        other: Complex<Double>,
        expected: Bool
    ) {
        let result: Bool = value.isOpposite(of: other)
        #expect(result == expected)
    }
}
