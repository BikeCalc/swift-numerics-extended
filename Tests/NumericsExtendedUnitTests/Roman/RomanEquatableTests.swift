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
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
    }

    @Test(
        "Inequality succeeds",
        arguments: Self.equalityArguments
    )
    internal func inequalitySucceeds(
        lhs: Roman,
        rhs: Roman,
        result: Bool
    ) {
        #expect((lhs != rhs) == !result)
    }

    @Test(
        "Is equal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isEqualSucceeds(
        lhs: Roman,
        rhs: Roman,
        result: Bool
    ) {
        #expect(lhs.isEqual(to: rhs) == result)
    }

    @Test(
        "Is unequal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isUnequalSucceeds(
        lhs: Roman,
        rhs: Roman,
        result: Bool
    ) {
        #expect(lhs.isUnequal(to: rhs) == !result)
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
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}
