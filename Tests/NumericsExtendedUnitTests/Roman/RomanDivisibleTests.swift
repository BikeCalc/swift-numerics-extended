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
    internal init() {}

    private static let divisionArguments: [(Roman, Roman.Divisor, Roman)] = [
        (6, 2, 3),
        (6, 3, 2)
    ]

    private static let remainderArguments: [(Roman, Roman.RemainderDivisor, Roman)] = [
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
        ] as Array<(Roman, Roman, Bool)>
    )
    internal func isDivisibleBy(
        dividend: Roman,
        divisor: Roman,
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
        ] as Array<(Roman, Roman, Bool)>
    )
    internal func isFactorOf(
        factor: Roman,
        value: Roman,
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
        dividend: Roman,
        divisor: Roman.Divisor,
        quotient: Roman
    ) {
        let result: Roman = dividend / divisor
        #expect(result == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: Roman,
        divisor: Roman.Divisor,
        quotient: Roman
    ) {
        var result: Roman = dividend
        result /= divisor
        #expect(result == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: Roman,
        divisor: Roman.RemainderDivisor,
        remainder: Roman
    ) {
        let result: Roman = dividend % divisor
        #expect(result == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: Roman,
        divisor: Roman.RemainderDivisor,
        remainder: Roman
    ) {
        var result: Roman = dividend
        result %= divisor
        #expect(result == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: Roman,
        divisor: Roman.Divisor,
        quotient: Roman
    ) throws {
        let result: Roman = try dividend.dividing(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: Roman,
        divisor: Roman.Divisor,
        quotient: Roman
    ) throws {
        var result: Roman = dividend
        try result.divide(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: Roman,
        quotient: Roman
    ) {
        let result: Roman = dividend.halved()
        #expect(result == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: Roman,
        quotient: Roman
    ) {
        var result: Roman = dividend
        result.halve()
        #expect(result == quotient)
    }
}

extension RomanDivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: Self.divisionArguments
    )
    internal func divisionIsNotCommutative(
        dividend: Roman,
        divisor: Roman.Divisor,
        quotient _: Roman
    ) {
        let result: Roman = dividend / divisor
        #expect(result != divisor / dividend)
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
        let result: Roman = dividend.halved()
        #expect(result == quotient)
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
        let result: Roman = dividend / 1
        #expect(result == dividend)
    }

    @Test(
        "Remainder by positive one returns positive zero",
        arguments: [
            6,
            4
        ] as Array<Roman>
    )
    internal func remainderByPositiveOneReturnsPositiveZero(dividend: Roman) {
        let result: Roman = dividend % 1
        #expect(result == Roman.zero)
    }
}

// MARK: - Positive Zero

extension RomanDivisibleTests {
    @Test(
        "Dividing positive zero by nonzero value returns positive zero",
        arguments: [
            2,
            3
        ] as Array<Roman.Divisor>
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveZero(divisor: Roman.Divisor) {
        let result: Roman = Roman.zero / divisor
        #expect(result == Roman.zero)
    }

    @Test(
        "Remainder by self returns positive zero",
        arguments: [
            6,
            4
        ] as Array<Roman>
    )
    internal func remainderBySelfReturnsPositiveZero(value: Roman) {
        let result: Roman = value % value
        #expect(result == Roman.zero)
    }
}
