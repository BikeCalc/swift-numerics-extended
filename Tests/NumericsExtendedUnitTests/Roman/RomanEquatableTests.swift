// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Equatable Tests")
internal struct RomanEquatableTests {
    internal init() {}

    private static let equalityArguments: Array<(Roman, Roman, Bool)> = [
        (1, 1, true),
        (1, 2, false)
    ]

    @Test(
        "Equality succeeds",
        arguments: Self.equalityArguments
    )
    internal func equalitySucceeds(
        lhs: Roman,
        rhs: Roman,
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
        lhs: Roman,
        rhs: Roman,
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
        lhs: Roman,
        rhs: Roman,
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
        lhs: Roman,
        rhs: Roman,
        expected: Bool
    ) throws {
        let result: Bool = try lhs.isUnequal(to: rhs)
        #expect(result == !expected)
    }
}

// MARK: - Positive Zero

extension RomanEquatableTests {
    @Test(
        "Positive zero equality follows integer rules",
        arguments: [
            (0, 0, true),
            (0, 1, false)
        ] as Array<(Roman, Roman, Bool)>
    )
    internal func positiveZeroEqualityFollowsIntegerRules(
        lhs: Roman,
        rhs: Roman,
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
