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
    internal init() {}

    private static let divisionArguments: [(Fraction<Int>, Fraction<Int>.Divisor, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 2), .init(1, 1)),
        (.init(1, 2), .init(2, 3), .init(3, 4)),
        (.init(-1, 2), .init(1, 2), .init(-1, 1)),
        (.init(-1, 2), .init(-2, 3), .init(3, 4))
    ]

    private static let remainderArguments: [(Fraction<Int>, Fraction<Int>.RemainderDivisor, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 2), .init(0, 1)),
        (.init(2, 3), .init(1, 2), .init(1, 6)),
        (.init(-2, 3), .init(1, 2), .init(-1, 6)),
        (.init(-2, 3), .init(-1, 2), .init(-1, 6))
    ]

    private static let halvingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 4)),
        (.init(2, 3), .init(1, 3)),
        (.init(-1, 2), .init(-1, 4)),
        (.init(-2, 3), .init(-1, 3))
    ]

    @Test(
        "Division succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionSucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        @Canonicalized var result: Fraction<Int> = dividend
        result /= divisor
        #expect(result == quotient)
    }

    @Test(
        "Divide succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideSucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) throws {
        @Canonicalized var result: Fraction<Int> = dividend
        try result.divide(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Remainder equal canonicalizes result",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualCanonicalizesResult(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.RemainderDivisor,
        remainder: Fraction<Int>
    ) {
        @Canonicalized var result: Fraction<Int> = dividend
        result %= divisor
        #expect(result == remainder)
    }

    @Test(
        "Halve canonicalizes result",
        arguments: Self.halvingArguments
    )
    internal func halveCanonicalizesResult(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        @Canonicalized var result: Fraction<Int> = dividend
        result.halve()
        #expect(result == quotient)
    }
}
