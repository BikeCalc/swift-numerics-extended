// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Multipliable Tests")
internal struct CanonicalizedFractionMultipliableTests {
    private static let multiplicationArguments: [(Fraction<Int>, Fraction<Int>.Multiplier, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(1, 4)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(1, 3)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(-1, 4)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(1, 3))
    ]

    @Test(
        "Multiplication succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationSucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        @Canonicalized
        var runningProduct: Fraction<Int> = multiplicand

        runningProduct *= multiplier

        #expect(runningProduct == product)
    }

    @Test(
        "Multiply succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplySucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) throws {
        @Canonicalized
        var runningProduct: Fraction<Int> = multiplicand

        try runningProduct.multiply(by: multiplier)

        #expect(runningProduct == product)
    }
}
