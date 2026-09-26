// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Raisable Tests")
internal struct CanonicalizedFractionRaisableTests {
    private static let exponentiationArguments: [(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), 2, Fraction<Int>(4, 9)),
        (Fraction<Int>(2, 3), 3, Fraction<Int>(8, 27)),
        (Fraction<Int>(2, 3), -2, Fraction<Int>(9, 4)),
        (Fraction<Int>(2, 3), -3, Fraction<Int>(27, 8)),
        (Fraction<Int>(-2, 3), 2, Fraction<Int>(4, 9)),
        (Fraction<Int>(-2, 3), 3, Fraction<Int>(-8, 27)),
        (Fraction<Int>(-2, 3), -2, Fraction<Int>(9, 4)),
        (Fraction<Int>(-2, 3), -3, Fraction<Int>(-27, 8)),
        (Fraction<Int>(1, 1), -2, Fraction<Int>(1, 1)),
        (Fraction<Int>(1, 1), -3, Fraction<Int>(1, 1)),
        (Fraction<Int>(-1, 1), -2, Fraction<Int>(1, 1)),
        (Fraction<Int>(-1, 1), -3, Fraction<Int>(-1, 1))
    ]

    private static let squaringArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), Fraction<Int>(4, 9)),
        (Fraction<Int>(3, 4), Fraction<Int>(9, 16)),
        (Fraction<Int>(-2, 3), Fraction<Int>(4, 9)),
        (Fraction<Int>(-3, 4), Fraction<Int>(9, 16))
    ]

    private static let cubingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), Fraction<Int>(8, 27)),
        (Fraction<Int>(3, 4), Fraction<Int>(27, 64)),
        (Fraction<Int>(-2, 3), Fraction<Int>(-8, 27)),
        (Fraction<Int>(-3, 4), Fraction<Int>(-27, 64))
    ]

    @Test(
        "Exponentiation equal canonicalizes result",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationEqualCanonicalizesResult(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        @Canonicalized
        var runningPower: Fraction<Int> = base

        runningPower **= exponent

        #expect(runningPower == power)
    }

    @Test(
        "Raise canonicalizes result",
        arguments: Self.exponentiationArguments
    )
    internal func raiseCanonicalizesResult(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        @Canonicalized
        var runningPower: Fraction<Int> = base

        runningPower.raise(to: exponent)

        #expect(runningPower == power)
    }

    @Test(
        "Square canonicalizes result",
        arguments: Self.squaringArguments
    )
    internal func squareCanonicalizesResult(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        @Canonicalized
        var value: Fraction<Int> = base

        value.square()

        #expect(value == power)
    }

    @Test(
        "Cube canonicalizes result",
        arguments: Self.cubingArguments
    )
    internal func cubeCanonicalizesResult(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        @Canonicalized
        var value: Fraction<Int> = base

        value.cube()

        #expect(value == power)
    }
}
