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
    internal init() {}

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
        let result: Int = -value
        #expect(result == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Int,
        negation: Int
    ) {
        let result: Int = value.negating()
        #expect(result == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Int,
        negation: Int
    ) {
        var result: Int = value
        result.negate()
        #expect(result == negation)
    }

    @Test(
        "Is negative",
        arguments: [
            (1, false),
            (-1, true),
            (5, false),
            (-5, true)
        ] as Array<(Int, Bool)>
    )
    internal func isNegative(
        value: Int,
        expected: Bool
    ) {
        #expect(value.isNegative == expected)
    }

    @Test(
        "Is positive",
        arguments: [
            (1, true),
            (-1, false),
            (5, true),
            (-5, false)
        ] as Array<(Int, Bool)>
    )
    internal func isPositive(
        value: Int,
        expected: Bool
    ) {
        #expect(value.isPositive == expected)
    }

    @Test(
        "Is signed",
        arguments: [
            (1, true),
            (-1, true),
            (5, true),
            (-5, true)
        ] as Array<(Int, Bool)>
    )
    internal func isSigned(
        value: Int,
        expected: Bool
    ) {
        #expect(value.isSigned == expected)
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
        ] as Array<(Int, Int, Bool)>
    )
    internal func isOpposite(
        value: Int,
        other: Int,
        expected: Bool
    ) {
        let result: Bool = value.isOpposite(of: other)
        #expect(result == expected)
    }
}

extension IntNegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Int) {
        let result: Int = value.negating().negating()
        #expect(result == value)
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
        let result: Bool = Int.negativeZero.isOpposite(of: .negativeZero)
        #expect(result == true)
    }

    @Test("Negating negative zero returns negative zero")
    internal func negatingNegativeZeroReturnsNegativeZero() {
        let operatorResult: Int = -Int.negativeZero
        let methodResult: Int = Int.negativeZero.negating()
        var mutatingResult: Int = Int.negativeZero
        mutatingResult.negate()
        #expect(operatorResult == .negativeZero)
        #expect(methodResult == .negativeZero)
        #expect(mutatingResult == .negativeZero)
    }
}

// MARK: - Positive Zero

extension IntNegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: Self.additiveInverseArguments
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Int) {
        let result: Int = value + value.negating()
        #expect(result == Int.zero)
    }

    @Test("Positive zero sign predicates follow integer rules")
    internal func positiveZeroSignPredicatesFollowIntegerRules() {
        #expect(Int.zero.isNegative == false)
        #expect(Int.zero.isPositive == false)
        #expect(Int.zero.isSigned == true)
    }

    @Test("Positive zero opposite follows integer rules")
    internal func positiveZeroOppositeFollowsIntegerRules() {
        let result: Bool = Int.zero.isOpposite(of: .zero)
        #expect(result == true)
    }

    @Test("Negating positive zero returns positive zero")
    internal func negatingPositiveZeroReturnsPositiveZero() {
        let operatorResult: Int = -Int.zero
        let methodResult: Int = Int.zero.negating()
        var mutatingResult: Int = Int.zero
        mutatingResult.negate()
        #expect(operatorResult == .zero)
        #expect(methodResult == .zero)
        #expect(mutatingResult == .zero)
    }
}
