// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Divisible Tests")
internal struct RomanDivisibleTests {
    private static let divisionArguments: [(Roman, Roman, Roman)] = [
        (6, 2, 3),
        (6, 3, 2)
    ]

    private static let remainderArguments: [(Roman, Roman, Roman)] = [
        (4, 2, 0),
        (5, 2, 1)
    ]

    private static let halvingArguments: [(Roman, Roman)] = [
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
        ] as Array<(Roman, Bool)>
    )
    internal func parityPredicates(
        value: Roman,
        result: Bool
    ) {
        #expect(value.isEven == result)
        #expect(value.isOdd == !result)
    }

    @Test(
        "Reciprocal",
        arguments: [
            (1, 1),
            (2, nil)
        ] as Array<(Roman, Roman?)>
    )
    internal func reciprocal(
        dividend: Roman,
        result: Roman?
    ) {
        #expect(dividend.reciprocal == result)
    }

    @Test(
        "Is divisible by",
        arguments: [
            (6, 3, true),
            (7, 3, false)
        ] as Array<(Roman, Roman, Bool)>
    )
    internal func isDivisibleBy(
        dividend: Roman,
        divisor: Roman,
        result: Bool
    ) {
        #expect(dividend.isDivisible(by: divisor) == result)
    }

    @Test(
        "Is factor of",
        arguments: [
            (3, 6, true),
            (3, 7, false)
        ] as Array<(Roman, Roman, Bool)>
    )
    internal func isFactorOf(
        factor: Roman,
        value: Roman,
        result: Bool
    ) {
        #expect(factor.isFactor(of: value) == result)
    }

    @Test(
        "Division succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionSucceeds(
        dividend: Roman,
        divisor: Roman,
        quotient: Roman
    ) {
        #expect(dividend / divisor == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: Roman,
        divisor: Roman,
        quotient: Roman
    ) {
        var runningQuotient: Roman = dividend
        runningQuotient /= divisor
        #expect(runningQuotient == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: Roman,
        divisor: Roman,
        remainder: Roman
    ) {
        #expect(dividend % divisor == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: Roman,
        divisor: Roman,
        remainder: Roman
    ) {
        var runningRemainder: Roman = dividend
        runningRemainder %= divisor
        #expect(runningRemainder == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: Roman,
        divisor: Roman,
        quotient: Roman
    ) {
        #expect(dividend.dividing(by: divisor) == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: Roman,
        divisor: Roman,
        quotient: Roman
    ) {
        var runningQuotient: Roman = dividend
        runningQuotient.divide(by: divisor)
        #expect(runningQuotient == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: Roman,
        quotient: Roman
    ) {
        #expect(dividend.halved() == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: Roman,
        quotient: Roman
    ) {
        var runningQuotient: Roman = dividend
        runningQuotient.halve()
        #expect(runningQuotient == quotient)
    }
}

extension RomanDivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: Self.divisionArguments
    )
    internal func divisionIsNotCommutative(
        dividend: Roman,
        divisor: Roman,
        quotient _: Roman
    ) {
        #expect(dividend / divisor != divisor / dividend)
    }

    @Test(
        "Halving odd values truncates toward zero",
        arguments: [
            (1, 0),
            (3, 1),
            (5, 2)
        ] as Array<(Roman, Roman)>
    )
    internal func halvingOddValuesTruncatesTowardZero(
        dividend: Roman,
        quotient: Roman
    ) {
        #expect(dividend.halved() == quotient)
    }
}

// MARK: - Positive One

extension RomanDivisibleTests {
    @Test(
        "Dividing by positive one preserves dividend",
        arguments: [
            6,
            4
        ] as Array<Roman>
    )
    internal func dividingByPositiveOnePreservesDividend(dividend: Roman) {
        #expect(dividend / 1 == dividend)
    }

    @Test(
        "Positive one invertibility follows unsigned integer rules",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(Roman, Bool)>
    )
    internal func positiveOneInvertibilityFollowsUnsignedIntegerRules(
        dividend: Roman,
        result: Bool
    ) {
        #expect(dividend.isInvertible == result)
    }

    @Test(
        "Remainder by positive one returns positive zero",
        arguments: [
            6,
            4
        ] as Array<Roman>
    )
    internal func remainderByPositiveOneReturnsPositiveZero(dividend: Roman) {
        #expect(dividend % 1 == Roman.zero)
    }
}

// MARK: - Positive Zero

extension RomanDivisibleTests {
    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(Roman.zero.isInvertible == false)
    }

    @Test(
        "Dividing positive zero by nonzero value returns positive zero",
        arguments: [
            2,
            3
        ] as Array<Roman>
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveZero(divisor: Roman) {
        #expect(Roman.zero / divisor == Roman.zero)
    }

    @Test(
        "Remainder by self returns positive zero",
        arguments: [
            6,
            4
        ] as Array<Roman>
    )
    internal func remainderBySelfReturnsPositiveZero(value: Roman) {
        #expect(value % value == Roman.zero)
    }
}
