// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Negateable Tests")
internal struct IntNegateableTests {
    private static let negationArguments: Array<(Int, Int)> = [
        (1, -1),
        (-1, 1),
        (5, -5),
        (-5, 5)
    ]

    private static let additiveInverseArguments: Array<Int> = [
        0,
        1,
        -1,
        5,
        -5
    ]

    @Test(
        "Negation succeeds",
        arguments: Self.negationArguments
    )
    internal func negationSucceeds(
        value: Int,
        negation: Int
    ) {
        #expect(-value == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Int,
        negation: Int
    ) {
        #expect(value.negating() == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Int,
        negation: Int
    ) {
        var runningValue: Int = value
        runningValue.negate()
        #expect(runningValue == negation)
    }

    @Test(
        "Is negative",
        arguments: [
            (1, false),
            (-1, true),
            (5, false),
            (-5, true)
        ]
    )
    internal func isNegative(
        value: Int,
        result: Bool
    ) {
        #expect(value.isNegative == result)
    }

    @Test(
        "Is positive",
        arguments: [
            (1, true),
            (-1, false),
            (5, true),
            (-5, false)
        ]
    )
    internal func isPositive(
        value: Int,
        result: Bool
    ) {
        #expect(value.isPositive == result)
    }

    @Test(
        "Is signed",
        arguments: [
            (1, true),
            (-1, true),
            (5, true),
            (-5, true)
        ]
    )
    internal func isSigned(
        value: Int,
        result: Bool
    ) {
        #expect(value.isSigned == result)
    }

    @Test(
        "Is opposite",
        arguments: [
            (1, 1, false),
            (-1, -1, false),
            (-1, 1, true),
            (1, -1, true),
            (5, 5, false),
            (-5, -5, false),
            (-5, 5, true),
            (5, -5, true)
        ]
    )
    internal func isOpposite(
        value: Int,
        other: Int,
        result: Bool
    ) {
        #expect(value.isOpposite(of: other) == result)
    }
}

extension IntNegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Int) {
        #expect(value.negating().negating() == value)
    }
}

// MARK: - Negative Zero

extension IntNegateableTests {
    @Test("Negative zero sign predicates follow integer rules")
    internal func negativeZeroSignPredicatesFollowIntegerRules() {
        #expect(Int.negativeZero.isNegative == false)
        #expect(Int.negativeZero.isPositive == false)
        #expect(Int.negativeZero.isSigned == true)
    }

    @Test("Negative zero opposite follows integer rules")
    internal func negativeZeroOppositeFollowsIntegerRules() {
        #expect(Int.negativeZero.isOpposite(of: .negativeZero) == true)
    }

    @Test("Negating negative zero returns negative zero")
    internal func negatingNegativeZeroReturnsNegativeZero() {
        let operatorNegation: Int = -Int.negativeZero
        let methodNegation: Int = Int.negativeZero.negating()
        var mutatingNegation: Int = Int.negativeZero
        mutatingNegation.negate()

        #expect(operatorNegation == .negativeZero)
        #expect(methodNegation == .negativeZero)
        #expect(mutatingNegation == .negativeZero)
    }
}

// MARK: - Positive Zero

extension IntNegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: Self.additiveInverseArguments
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Int) {
        #expect(value + value.negating() == Int.zero)
    }

    @Test("Positive zero sign predicates follow integer rules")
    internal func positiveZeroSignPredicatesFollowIntegerRules() {
        #expect(Int.zero.isNegative == false)
        #expect(Int.zero.isPositive == false)
        #expect(Int.zero.isSigned == true)
    }

    @Test("Positive zero opposite follows integer rules")
    internal func positiveZeroOppositeFollowsIntegerRules() {
        #expect(Int.zero.isOpposite(of: .zero) == true)
    }

    @Test("Negating positive zero returns positive zero")
    internal func negatingPositiveZeroReturnsPositiveZero() {
        let operatorNegation: Int = -Int.zero
        let methodNegation: Int = Int.zero.negating()
        var mutatingNegation: Int = Int.zero
        mutatingNegation.negate()

        #expect(operatorNegation == .zero)
        #expect(methodNegation == .zero)
        #expect(mutatingNegation == .zero)
    }
}
