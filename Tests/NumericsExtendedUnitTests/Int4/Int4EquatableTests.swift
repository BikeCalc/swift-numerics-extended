// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Equatable Tests")
internal struct Int4EquatableTests {
    private static let equalityArguments: Array<(Int4, Int4, Bool)> = [
        (1, 1, true),
        (1, 2, false),
        (-1, -1, true),
        (-1, 1, false)
    ]

    @Test(
        "Equality succeeds",
        arguments: Self.equalityArguments
    )
    internal func equalitySucceeds(
        lhs: Int4,
        rhs: Int4,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
    }

    @Test(
        "Inequality succeeds",
        arguments: Self.equalityArguments
    )
    internal func inequalitySucceeds(
        lhs: Int4,
        rhs: Int4,
        result: Bool
    ) {
        #expect((lhs != rhs) == !result)
    }

    @Test(
        "Is equal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isEqualSucceeds(
        lhs: Int4,
        rhs: Int4,
        result: Bool
    ) {
        #expect(lhs.isEqual(to: rhs) == result)
    }

    @Test(
        "Is unequal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isUnequalSucceeds(
        lhs: Int4,
        rhs: Int4,
        result: Bool
    ) {
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Negative Zero

extension Int4EquatableTests {
    @Test(
        "Negative zero equality follows integer rules",
        arguments: [
            (Int4.negativeZero, Int4.negativeZero, true),
            (Int4.negativeZero, Int4.zero, true),
            (Int4.negativeZero, 1, false)
        ]
    )
    internal func negativeZeroEqualityFollowsIntegerRules(
        lhs: Int4,
        rhs: Int4,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Positive Zero

extension Int4EquatableTests {
    @Test(
        "Positive zero equality follows integer rules",
        arguments: [
            (Int4.zero, Int4.zero, true),
            (Int4.zero, Int4.negativeZero, true),
            (Int4.zero, 1, false)
        ]
    )
    internal func positiveZeroEqualityFollowsIntegerRules(
        lhs: Int4,
        rhs: Int4,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}
