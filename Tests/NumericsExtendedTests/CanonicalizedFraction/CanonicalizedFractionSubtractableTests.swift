// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Subtractable Tests")
internal struct CanonicalizedFractionSubtractableTests {
    private static let subtractionArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), Fraction<Int>(1, 2), Fraction<Int>(1, 6)),
        (Fraction<Int>(3, 4), Fraction<Int>(1, 2), Fraction<Int>(1, 4)),
        (Fraction<Int>(-2, 3), Fraction<Int>(1, 2), Fraction<Int>(-7, 6)),
        (Fraction<Int>(-3, 4), Fraction<Int>(-1, 2), Fraction<Int>(-1, 4))
    ]

    @Test(
        "Subtraction equal canonicalizes result",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualCanonicalizesResult(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        @Canonicalized
        var runningDifference: Fraction<Int> = minuend

        runningDifference -= subtrahend

        #expect(runningDifference == difference)
    }

    @Test(
        "Subtract canonicalizes result",
        arguments: Self.subtractionArguments
    )
    internal func subtractCanonicalizesResult(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        @Canonicalized
        var runningDifference: Fraction<Int> = minuend

        runningDifference.subtract(subtrahend)

        #expect(runningDifference == difference)
    }
}
