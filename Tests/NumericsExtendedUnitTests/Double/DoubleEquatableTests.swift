// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Equatable Tests")
internal struct DoubleEquatableTests {
    internal init() {}

    private static let equalityArguments: Array<(Double, Double)> = [
        (1.0, 1.0),
        (1.0, 2.0),
        (-1.0, -1.0),
        (-1.0, 1.0),
        (0.5, 0.5),
        (0.5, 1.5),
        (-0.5, -0.5),
        (-0.5, 0.5)
    ]

    @Test(
        "Equality predicates",
        arguments: Self.equalityArguments
    )
    internal func equalityPredicates(
        lhs: Double,
        rhs: Double
    ) throws {
        let isEqualResult: Bool = lhs.isEqual(to: rhs)
        #expect(isEqualResult == (lhs == rhs))
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == (lhs != rhs))
    }
}

// MARK: - NaN

extension DoubleEquatableTests {
    @Test(
        "NaN equality follows floating-point rules",
        arguments: [
            (.nan, .nan),
            (.nan, 1.0),
            (1.0, .nan)
        ] as Array<(Double, Double)>
    )
    internal func nanEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == false)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == true)
        let isEqualResult: Bool = lhs.isEqual(to: rhs)
        #expect(isEqualResult == false)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == true)
    }
}

// MARK: - Negative Infinity

extension DoubleEquatableTests {
    @Test(
        "Negative infinity equality follows floating-point rules",
        arguments: [
            (.negativeInfinity, .negativeInfinity, true),
            (.negativeInfinity, .infinity, false)
        ] as Array<(Double, Double, Bool)>
    )
    internal func negativeInfinityEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        expected: Bool
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = lhs.isEqual(to: rhs)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Negative Zero

extension DoubleEquatableTests {
    @Test(
        "Negative zero equality follows floating-point rules",
        arguments: [
            (.negativeZero, .negativeZero, true),
            (.negativeZero, .zero, true),
            (.negativeZero, -1.0, false)
        ] as Array<(Double, Double, Bool)>
    )
    internal func negativeZeroEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        expected: Bool
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = lhs.isEqual(to: rhs)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Positive Infinity

extension DoubleEquatableTests {
    @Test(
        "Positive infinity equality follows floating-point rules",
        arguments: [
            (.infinity, .infinity, true),
            (.infinity, .negativeInfinity, false)
        ] as Array<(Double, Double, Bool)>
    )
    internal func positiveInfinityEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        expected: Bool
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = lhs.isEqual(to: rhs)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Positive Zero

extension DoubleEquatableTests {
    @Test(
        "Positive zero equality follows floating-point rules",
        arguments: [
            (.zero, .zero, true),
            (.zero, .negativeZero, true),
            (.zero, 1.0, false)
        ] as Array<(Double, Double, Bool)>
    )
    internal func positiveZeroEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        expected: Bool
    ) throws {
        let equalityResult: Bool = lhs == rhs
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhs != rhs
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = lhs.isEqual(to: rhs)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhs.isUnequal(to: rhs)
        #expect(isUnequalResult == !expected)
    }
}
