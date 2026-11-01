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
    internal init() {}

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
        expected: Bool
    ) {
        let result: Bool = lhs == rhs
        #expect(result == expected)
    }

    @Test(
        "Inequality succeeds",
        arguments: Self.equalityArguments
    )
    internal func inequalitySucceeds(
        lhs: Int4,
        rhs: Int4,
        expected: Bool
    ) {
        let result: Bool = lhs != rhs
        #expect(result == !expected)
    }

    @Test(
        "Is equal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isEqualSucceeds(
        lhs: Int4,
        rhs: Int4,
        expected: Bool
    ) throws {
        let result: Bool = try lhs.isEqual(to: rhs)
        #expect(result == expected)
    }

    @Test(
        "Is unequal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isUnequalSucceeds(
        lhs: Int4,
        rhs: Int4,
        expected: Bool
    ) throws {
        let result: Bool = try lhs.isUnequal(to: rhs)
        #expect(result == !expected)
    }
}

// MARK: - Negative Zero

extension Int4EquatableTests {
    @Test(
        "Negative zero equality follows integer rules",
        arguments: [
            (.negativeZero, .negativeZero, true),
            (.negativeZero, .zero, true),
            (.negativeZero, 1, false)
        ] as Array<(Int4, Int4, Bool)>
    )
    internal func negativeZeroEqualityFollowsIntegerRules(
        lhs: Int4,
        rhs: Int4,
        expected: Bool
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhs.isEqual(to: rhs)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Positive Zero

extension Int4EquatableTests {
    @Test(
        "Positive zero equality follows integer rules",
        arguments: [
            (.zero, .zero, true),
            (.zero, .negativeZero, true),
            (.zero, 1, false)
        ] as Array<(Int4, Int4, Bool)>
    )
    internal func positiveZeroEqualityFollowsIntegerRules(
        lhs: Int4,
        rhs: Int4,
        expected: Bool
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhs.isEqual(to: rhs)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == !expected)
    }
}
