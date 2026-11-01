// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Equatable Tests")
internal struct FractionEquatableTests {
    internal init() {}

    private static let equalityArguments: [(Fraction<Int>, Fraction<Int>, Bool)] = [
        (.init(1, 2), .init(1, 2), true),
        (.init(1, 2), .init(2, 3), false),
        (.init(1, 2), .init(2, 4), false),
        (.init(-1, 2), .init(-1, 2), true),
        (.init(-1, 2), .init(-2, 3), false),
        (.init(-1, 2), .init(1, -2), false)
    ]

    @Test(
        "Equality succeeds",
        arguments: Self.equalityArguments
    )
    internal func equalitySucceeds(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) throws {
        let result: Bool = try lhs.isUnequal(to: rhs)
        #expect(result == !expected)
    }
}

// MARK: - NaN

extension FractionEquatableTests {
    @Test(
        "NaN equality follows rational rules",
        arguments: [
            (.nan, .nan, false),
            (.nan, .init(1, 1), false),
            (.init(1, 1), .nan, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func nanEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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

// MARK: - Negative Infinity

extension FractionEquatableTests {
    @Test(
        "Negative infinity equality follows rational rules",
        arguments: [
            (.negativeInfinity, .negativeInfinity, true),
            (.negativeInfinity, .infinity, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func negativeInfinityEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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

// MARK: - Negative Zero

extension FractionEquatableTests {
    @Test(
        "Negative zero equality follows stored representation rules",
        arguments: [
            (.negativeZero, .negativeZero, true),
            (.negativeZero, .zero, false),
            (.negativeZero, .init(-1, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func negativeZeroEqualityFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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

// MARK: - Positive Infinity

extension FractionEquatableTests {
    @Test(
        "Positive infinity equality follows rational rules",
        arguments: [
            (.infinity, .infinity, true),
            (.infinity, .negativeInfinity, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func positiveInfinityEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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

extension FractionEquatableTests {
    @Test(
        "Positive zero equality follows stored representation rules",
        arguments: [
            (.zero, .zero, true),
            (.zero, .negativeZero, false),
            (.zero, .init(1, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func positiveZeroEqualityFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
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
