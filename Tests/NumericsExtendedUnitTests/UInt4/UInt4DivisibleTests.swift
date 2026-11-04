// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Divisible Tests")
internal struct UInt4DivisibleTests {
    internal init() {}

    private static let divisionArguments: [(UInt4, UInt4.Divisor, UInt4)] = [
        (6, 2, 3),
        (6, 3, 2)
    ]

    private static let remainderArguments: [(UInt4, UInt4.RemainderDivisor, UInt4)] = [
        (4, 2, 0),
        (5, 2, 1)
    ]

    private static let halvingArguments: [(UInt4, UInt4)] = [
        (6, 3),
        (4, 2)
    ]

    @Test(
        "Parity predicates",
        arguments: [
            (0, true),
            (1, false),
            (2, true),
            (3, false)
        ] as Array<(UInt4, Bool)>
    )
    internal func parityPredicates(
        value: UInt4,
        expected: Bool
    ) {
        #expect(value.isEven == expected)
        #expect(value.isOdd == !expected)
    }

    @Test(
        "Is divisible by",
        arguments: [
            (6, 3, true),
            (7, 3, false)
        ] as Array<(UInt4, UInt4, Bool)>
    )
    internal func isDivisibleBy(
        dividend: UInt4,
        divisor: UInt4,
        expected: Bool
    ) {
        let result: Bool = dividend.isDivisible(by: divisor)
        #expect(result == expected)
    }

    @Test(
        "Is factor of",
        arguments: [
            (3, 6, true),
            (3, 7, false)
        ] as Array<(UInt4, UInt4, Bool)>
    )
    internal func isFactorOf(
        factor: UInt4,
        value: UInt4,
        expected: Bool
    ) {
        let result: Bool = factor.isFactor(of: value)
        #expect(result == expected)
    }

    @Test(
        "Division succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionSucceeds(
        dividend: UInt4,
        divisor: UInt4.Divisor,
        quotient: UInt4
    ) {
        let result: UInt4 = dividend / divisor
        #expect(result == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: UInt4,
        divisor: UInt4.Divisor,
        quotient: UInt4
    ) {
        var result: UInt4 = dividend
        result /= divisor
        #expect(result == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: UInt4,
        divisor: UInt4.RemainderDivisor,
        remainder: UInt4
    ) {
        let result: UInt4 = dividend % divisor
        #expect(result == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: UInt4,
        divisor: UInt4.RemainderDivisor,
        remainder: UInt4
    ) {
        var result: UInt4 = dividend
        result %= divisor
        #expect(result == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: UInt4,
        divisor: UInt4.Divisor,
        quotient: UInt4
    ) throws {
        let result: UInt4 = try dividend.dividing(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: UInt4,
        divisor: UInt4.Divisor,
        quotient: UInt4
    ) throws {
        var result: UInt4 = dividend
        try result.divide(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: UInt4,
        quotient: UInt4
    ) {
        let result: UInt4 = dividend.halved()
        #expect(result == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: UInt4,
        quotient: UInt4
    ) {
        var result: UInt4 = dividend
        result.halve()
        #expect(result == quotient)
    }
}

extension UInt4DivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: Self.divisionArguments
    )
    internal func divisionIsNotCommutative(
        dividend: UInt4,
        divisor: UInt4.Divisor,
        quotient _: UInt4
    ) {
        let result: UInt4 = dividend / divisor
        #expect(result != divisor / dividend)
    }

    @Test(
        "Halving odd values truncates toward zero",
        arguments: [
            (1, 0),
            (3, 1),
            (5, 2)
        ] as Array<(UInt4, UInt4)>
    )
    internal func halvingOddValuesTruncatesTowardZero(
        dividend: UInt4,
        quotient: UInt4
    ) {
        let result: UInt4 = dividend.halved()
        #expect(result == quotient)
    }
}

// MARK: - Positive One

extension UInt4DivisibleTests {
    @Test(
        "Dividing by positive one preserves dividend",
        arguments: [
            6,
            4
        ] as Array<UInt4>
    )
    internal func dividingByPositiveOnePreservesDividend(dividend: UInt4) {
        let result: UInt4 = dividend / 1
        #expect(result == dividend)
    }

    @Test(
        "Remainder by positive one returns positive zero",
        arguments: [
            6,
            4
        ] as Array<UInt4>
    )
    internal func remainderByPositiveOneReturnsPositiveZero(dividend: UInt4) {
        let result: UInt4 = dividend % 1
        #expect(result == UInt4.zero)
    }
}

// MARK: - Positive Zero

extension UInt4DivisibleTests {
    @Test(
        "Dividing positive zero by nonzero value returns positive zero",
        arguments: [
            2,
            3
        ] as Array<UInt4.Divisor>
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveZero(divisor: UInt4.Divisor) {
        let result: UInt4 = UInt4.zero / divisor
        #expect(result == UInt4.zero)
    }

    @Test(
        "Remainder by self returns positive zero",
        arguments: [
            6,
            4
        ] as Array<UInt4>
    )
    internal func remainderBySelfReturnsPositiveZero(value: UInt4) {
        let result: UInt4 = value % value
        #expect(result == UInt4.zero)
    }
}
