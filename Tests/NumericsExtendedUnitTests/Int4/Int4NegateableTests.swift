// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Negateable Tests")
internal struct Int4NegateableTests {
    internal init() {}

    private static let negationArguments: Array<(Int4, Int4)> = [
        (1, -1),
        (-1, 1),
        (5, -5),
        (-5, 5)
    ]

    private static let additiveInverseArguments: Array<Int4> = [
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
        value: Int4,
        negation: Int4
    ) {
        let result: Int4 = -value
        #expect(result == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Int4,
        negation: Int4
    ) {
        let result: Int4 = value.negating()
        #expect(result == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Int4,
        negation: Int4
    ) {
        var result: Int4 = value
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
        ] as Array<(Int4, Bool)>
    )
    internal func isNegative(
        value: Int4,
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
        ] as Array<(Int4, Bool)>
    )
    internal func isPositive(
        value: Int4,
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
        ] as Array<(Int4, Bool)>
    )
    internal func isSigned(
        value: Int4,
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
        ] as Array<(Int4, Int4, Bool)>
    )
    internal func isOpposite(
        value: Int4,
        other: Int4,
        expected: Bool
    ) {
        let result: Bool = value.isOpposite(of: other)
        #expect(result == expected)
    }
}

extension Int4NegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Int4) {
        let result: Int4 = value.negating().negating()
        #expect(result == value)
    }
}

// MARK: - Negative Zero

extension Int4NegateableTests {
    @Test("Negative zero sign predicates follow integer rules")
    internal func negativeZeroSignPredicatesFollowIntegerRules() {
        #expect(Int4.negativeZero.isNegative == false)
        #expect(Int4.negativeZero.isPositive == false)
        #expect(Int4.negativeZero.isSigned == true)
    }

    @Test("Negative zero opposite follows integer rules")
    internal func negativeZeroOppositeFollowsIntegerRules() {
        let result: Bool = Int4.negativeZero.isOpposite(of: .negativeZero)
        #expect(result == true)
    }

    @Test("Negating negative zero returns negative zero")
    internal func negatingNegativeZeroReturnsNegativeZero() {
        let operatorResult: Int4 = -Int4.negativeZero
        let methodResult: Int4 = Int4.negativeZero.negating()
        var mutatingResult: Int4 = Int4.negativeZero
        mutatingResult.negate()
        #expect(operatorResult == .negativeZero)
        #expect(methodResult == .negativeZero)
        #expect(mutatingResult == .negativeZero)
    }
}

// MARK: - Positive Zero

extension Int4NegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: Self.additiveInverseArguments
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Int4) {
        let result: Int4 = value + value.negating()
        #expect(result == Int4.zero)
    }

    @Test("Positive zero sign predicates follow integer rules")
    internal func positiveZeroSignPredicatesFollowIntegerRules() {
        #expect(Int4.zero.isNegative == false)
        #expect(Int4.zero.isPositive == false)
        #expect(Int4.zero.isSigned == true)
    }

    @Test("Positive zero opposite follows integer rules")
    internal func positiveZeroOppositeFollowsIntegerRules() {
        let result: Bool = Int4.zero.isOpposite(of: .zero)
        #expect(result == true)
    }

    @Test("Negating positive zero returns positive zero")
    internal func negatingPositiveZeroReturnsPositiveZero() {
        let operatorResult: Int4 = -Int4.zero
        let methodResult: Int4 = Int4.zero.negating()
        var mutatingResult: Int4 = Int4.zero
        mutatingResult.negate()
        #expect(operatorResult == .zero)
        #expect(methodResult == .zero)
        #expect(mutatingResult == .zero)
    }
}
