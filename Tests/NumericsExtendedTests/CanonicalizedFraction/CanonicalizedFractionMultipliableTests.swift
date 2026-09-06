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
    private static let multiplicationArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(1, 4)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(1, 3)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(-1, 4)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(1, 3))
    ]

    @Test(
        "Multiplication equal canonicalizes result",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualCanonicalizesResult(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        @Canonicalized
        var runningProduct: Fraction<Int> = multiplicand

        runningProduct *= multiplier
        
        #expect(runningProduct == product)
    }

    @Test(
        "Multiply canonicalizes result",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyCanonicalizesResult(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        @Canonicalized
        var runningProduct: Fraction<Int> = multiplicand

        runningProduct.multiply(by: multiplier)

        #expect(runningProduct == product)
    }
}
