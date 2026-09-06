// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Equatable Tests")
internal struct UInt4EquatableTests {
    private static let equalityArguments: Array<(UInt4, UInt4, Bool)> = [
        (1, 1, true),
        (1, 2, false)
    ]

    @Test(
        "Equality succeeds",
        arguments: Self.equalityArguments
    )
    internal func equalitySucceeds(
        lhs: UInt4,
        rhs: UInt4,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
    }

    @Test(
        "Inequality succeeds",
        arguments: Self.equalityArguments
    )
    internal func inequalitySucceeds(
        lhs: UInt4,
        rhs: UInt4,
        result: Bool
    ) {
        #expect((lhs != rhs) == !result)
    }

    @Test(
        "Is equal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isEqualSucceeds(
        lhs: UInt4,
        rhs: UInt4,
        result: Bool
    ) {
        #expect(lhs.isEqual(to: rhs) == result)
    }

    @Test(
        "Is unequal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isUnequalSucceeds(
        lhs: UInt4,
        rhs: UInt4,
        result: Bool
    ) {
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Positive Zero

extension UInt4EquatableTests {
    @Test(
        "Positive zero equality follows integer rules",
        arguments: [
            (0, 0, true),
            (0, 1, false)
        ] as Array<(UInt4, UInt4, Bool)>
    )
    internal func positiveZeroEqualityFollowsIntegerRules(
        lhs: UInt4,
        rhs: UInt4,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}
