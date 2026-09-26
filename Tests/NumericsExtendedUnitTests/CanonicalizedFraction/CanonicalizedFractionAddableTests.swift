// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Addable Tests")
internal struct CanonicalizedFractionAddableTests {
    private static let additionArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(1, 1)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(7, 6)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(0, 1)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(-7, 6))
    ]

    @Test(
        "Addition equal canonicalizes result",
        arguments: Self.additionArguments
    )
    internal func additionEqualCanonicalizesResult(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        @Canonicalized
        var runningSum: Fraction<Int> = augend

        runningSum += addend

        #expect(runningSum == sum)
    }

    @Test(
        "Add canonicalizes result",
        arguments: Self.additionArguments
    )
    internal func addCanonicalizesResult(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        @Canonicalized
        var runningSum: Fraction<Int> = augend

        runningSum.add(addend)

        #expect(runningSum == sum)
    }
}
