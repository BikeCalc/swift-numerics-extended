// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Divisible Tests")
internal struct IntDivisibleTests {
    internal init() {}

    private static let divisionArguments: [(Int, Int.Divisor, Int)] = [
        (6, 2, 3),
        (6, 3, 2),
        (-6, 2, -3),
        (-6, -3, 2)
    ]

    private static let remainderArguments: [(Int, Int.RemainderDivisor, Int)] = [
        (4, 2, 0),
        (5, 2, 1),
        (5, -2, 1),
        (-5, 2, -1),
        (-5, -2, -1)
    ]

    private static let halvingArguments: [(Int, Int)] = [
        (6, 3),
        (4, 2),
        (-6, -3),
        (-4, -2)
    ]

    @Test(
        "Parity predicates",
        arguments: [
            (0, true),
            (1, false),
            (2, true),
            (3, false),
            (-1, false),
            (-2, true),
            (-3, false)
        ]
    )
    internal func parityPredicates(
        value: Int,
        expected: Bool
    ) {
        #expect(value.isEven == expected)
        #expect(value.isOdd == !expected)
    }

    @Test(
        "Reciprocal",
        arguments: [
            (1, 1),
            (-1, -1),
            (2, nil),
            (-2, nil)
        ]
    )
    internal func reciprocal(
        dividend: Int,
        expected: Int?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is divisible by",
        arguments: [
            (6, 3, true),
            (7, 3, false),
            (-6, 3, true),
            (-7, 3, false)
        ]
    )
    internal func isDivisibleBy(
        dividend: Int,
        divisor: Int,
        expected: Bool
    ) {
        let result: Bool = dividend.isDivisible(by: divisor)
        #expect(result == expected)
    }

    @Test(
        "Is factor of",
        arguments: [
            (3, 6, true),
            (3, 7, false),
            (3, -6, true),
            (3, -7, false)
        ]
    )
    internal func isFactorOf(
        factor: Int,
        value: Int,
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
        dividend: Int,
        divisor: Int.Divisor,
        quotient: Int
    ) {
        let result: Int = dividend / divisor
        #expect(result == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: Int,
        divisor: Int.Divisor,
        quotient: Int
    ) {
        var result: Int = dividend
        result /= divisor
        #expect(result == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: Int,
        divisor: Int.RemainderDivisor,
        remainder: Int
    ) {
        let result: Int = dividend % divisor
        #expect(result == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: Int,
        divisor: Int.RemainderDivisor,
        remainder: Int
    ) {
        var result: Int = dividend
        result %= divisor
        #expect(result == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: Int,
        divisor: Int.Divisor,
        quotient: Int
    ) throws {
        let result: Int = try dividend.dividing(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: Int,
        divisor: Int.Divisor,
        quotient: Int
    ) throws {
        var result: Int = dividend
        try result.divide(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: Int,
        quotient: Int
    ) {
        let result: Int = dividend.halved()
        #expect(result == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: Int,
        quotient: Int
    ) {
        var result: Int = dividend
        result.halve()
        #expect(result == quotient)
    }
}

extension IntDivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: Self.divisionArguments
    )
    internal func divisionIsNotCommutative(
        dividend: Int,
        divisor: Int.Divisor,
        quotient _: Int
    ) {
        let result: Int = dividend / divisor
        #expect(result != divisor / dividend)
    }

    @Test(
        "Halving odd values truncates toward zero",
        arguments: [
            (1, 0),
            (-1, 0),
            (3, 1),
            (-3, -1),
            (5, 2),
            (-5, -2)
        ]
    )
    internal func halvingOddValuesTruncatesTowardZero(
        dividend: Int,
        quotient: Int
    ) {
        let result: Int = dividend.halved()
        #expect(result == quotient)
    }

    @Test(
        "Integer division truncates toward zero",
        arguments: [
            (7, 3, 2),
            (-7, 3, -2),
            (7, -3, -2),
            (-7, -3, 2)
        ]
    )
    internal func integerDivisionTruncatesTowardZero(
        dividend: Int,
        divisor: Int.Divisor,
        quotient: Int
    ) {
        let result: Int = dividend / divisor
        #expect(result == quotient)
    }
}

// MARK: - Negative One

extension IntDivisibleTests {
    @Test(
        "Dividing by negative one returns opposite value",
        arguments: [
            (6, -6),
            (4, -4),
            (-6, 6),
            (-4, 4)
        ]
    )
    internal func dividingByNegativeOneReturnsOppositeValue(
        dividend: Int,
        quotient: Int
    ) {
        let result: Int = dividend / -1
        #expect(result == quotient)
    }

    @Test(
        "Negative one invertibility follows integer rules",
        arguments: [
            (-1, true),
            (-2, false)
        ]
    )
    internal func negativeOneInvertibilityFollowsIntegerRules(
        dividend: Int,
        expected: Bool
    ) {
        #expect(dividend.isInvertible == expected)
    }

    @Test(
        "Remainder by negative one returns positive zero",
        arguments: [
            6,
            4,
            -6,
            -4
        ]
    )
    internal func remainderByNegativeOneReturnsPositiveZero(dividend: Int) {
        let result: Int = dividend % -1
        #expect(result == Int.zero)
    }
}

// MARK: - Negative Zero

extension IntDivisibleTests {
    @Test(
        "Negative zero is not invertible",
        arguments: [
            0,
            -0
        ]
    )
    internal func negativeZeroIsNotInvertible(dividend: Int) {
        #expect(dividend.isInvertible == false)
    }

    @Test(
        "Dividing negative zero by nonzero value returns negative zero",
        arguments: [
            2,
            -3,
            3
        ]
    )
    internal func dividingNegativeZeroByNonzeroValueReturnsNegativeZero(divisor: Int.Divisor) {
        let result: Int = Int.negativeZero / divisor
        #expect(result == Int.negativeZero)
    }
}

// MARK: - Positive One

extension IntDivisibleTests {
    @Test(
        "Dividing by positive one preserves dividend",
        arguments: [
            6,
            4,
            -6,
            -4
        ]
    )
    internal func dividingByPositiveOnePreservesDividend(dividend: Int) {
        let result: Int = dividend / 1
        #expect(result == dividend)
    }

    @Test(
        "Positive one invertibility follows integer rules",
        arguments: [
            (1, true),
            (2, false)
        ]
    )
    internal func positiveOneInvertibilityFollowsIntegerRules(
        dividend: Int,
        expected: Bool
    ) {
        #expect(dividend.isInvertible == expected)
    }

    @Test(
        "Remainder by positive one returns positive zero",
        arguments: [
            6,
            4,
            -6,
            -4
        ]
    )
    internal func remainderByPositiveOneReturnsPositiveZero(dividend: Int) {
        let result: Int = dividend % 1
        #expect(result == Int.zero)
    }
}

// MARK: - Positive Zero

extension IntDivisibleTests {
    @Test(
        "Positive zero is not invertible",
        arguments: [
            0,
            -0
        ]
    )
    internal func positiveZeroIsNotInvertible(dividend: Int) {
        #expect(dividend.isInvertible == false)
    }

    @Test(
        "Dividing positive zero by nonzero value returns positive zero",
        arguments: [
            2,
            -3,
            3
        ]
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveZero(divisor: Int.Divisor) {
        let result: Int = Int.zero / divisor
        #expect(result == Int.zero)
    }

    @Test(
        "Remainder by self returns positive zero",
        arguments: [
            6,
            4,
            -6,
            -4
        ]
    )
    internal func remainderBySelfReturnsPositiveZero(value: Int) {
        let result: Int = value % value
        #expect(result == Int.zero)
    }
}
