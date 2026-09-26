// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Equatable Tests")
internal struct IntEquatableTests {
    private static let equalityArguments: Array<(Int, Int)> = [
        (1, 1),
        (1, 2),
        (-1, -1),
        (-1, 1)
    ]

    @Test(
        "Equality predicates",
        arguments: Self.equalityArguments
    )
    internal func equalityPredicates(
        lhs: Int,
        rhs: Int
    ) {
        #expect(lhs.isEqual(to: rhs) == (lhs == rhs))
        #expect(lhs.isUnequal(to: rhs) == (lhs != rhs))
    }
}

// MARK: - Negative Zero

extension IntEquatableTests {
    @Test(
        "Negative zero equality follows integer rules",
        arguments: [
            (Int.negativeZero, Int.negativeZero, true),
            (Int.negativeZero, Int.zero, true),
            (Int.negativeZero, 1, false)
        ]
    )
    internal func negativeZeroEqualityFollowsIntegerRules(
        lhs: Int,
        rhs: Int,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Positive Zero

extension IntEquatableTests {
    @Test(
        "Positive zero equality follows integer rules",
        arguments: [
            (Int.zero, Int.zero, true),
            (Int.zero, Int.negativeZero, true),
            (Int.zero, 1, false)
        ]
    )
    internal func positiveZeroEqualityFollowsIntegerRules(
        lhs: Int,
        rhs: Int,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}
