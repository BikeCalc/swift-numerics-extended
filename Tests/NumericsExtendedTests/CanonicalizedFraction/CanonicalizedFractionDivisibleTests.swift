// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Divisible Tests")
internal struct CanonicalizedFractionDivisibleTests {
    private static let divisionArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(1, 1)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(3, 4)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(-1, 1)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(3, 4))
    ]

    private static let remainderArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(0, 1)),
        (Fraction<Int>(2, 3), Fraction<Int>(1, 2), Fraction<Int>(1, 6)),
        (Fraction<Int>(-2, 3), Fraction<Int>(1, 2), Fraction<Int>(-1, 6)),
        (Fraction<Int>(-2, 3), Fraction<Int>(-1, 2), Fraction<Int>(-1, 6))
    ]

    private static let halvingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 4)),
        (Fraction<Int>(2, 3), Fraction<Int>(1, 3)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 4)),
        (Fraction<Int>(-2, 3), Fraction<Int>(-1, 3))
    ]

    @Test(
        "Division equal canonicalizes result",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualCanonicalizesResult(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        @Canonicalized
        var runningQuotient: Fraction<Int> = dividend

        runningQuotient /= divisor

        #expect(runningQuotient == quotient)
    }

    @Test(
        "Divide canonicalizes result",
        arguments: Self.divisionArguments
    )
    internal func divideCanonicalizesResult(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        @Canonicalized
        var runningQuotient: Fraction<Int> = dividend

        runningQuotient.divide(by: divisor)

        #expect(runningQuotient == quotient)
    }

    @Test(
        "Remainder equal canonicalizes result",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualCanonicalizesResult(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>,
        remainder: Fraction<Int>
    ) {
        @Canonicalized
        var runningRemainder: Fraction<Int> = dividend

        runningRemainder %= divisor

        #expect(runningRemainder == remainder)
    }

    @Test(
        "Halve canonicalizes result",
        arguments: Self.halvingArguments
    )
    internal func halveCanonicalizesResult(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        @Canonicalized
        var runningQuotient: Fraction<Int> = dividend

        runningQuotient.halve()
        
        #expect(runningQuotient == quotient)
    }
}
