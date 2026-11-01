// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Equatable Tests")
internal struct CanonicalizedFractionEquatableTests {
    internal init() {}

    private static let equalityArguments: [(Fraction<Int>, Fraction<Int>, Bool)] = [
        (.init(1, 2), .init(1, 2), true),
        (.init(1, 2), .init(2, 3), false),
        (.init(1, 2), .init(2, 4), true),
        (.init(-1, 2), .init(-1, 2), true),
        (.init(-1, 2), .init(-2, 3), false),
        (.init(-1, 2), .init(1, -2), true)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let result: Bool = lhsWrapper == rhsWrapper
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let result: Bool = lhsWrapper != rhsWrapper
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let result: Bool = try lhsWrapper.isEqual(to: rhsWrapper)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let result: Bool = try lhsWrapper.isUnequal(to: rhsWrapper)
        #expect(result == !expected)
    }
}

// MARK: - NaN

extension CanonicalizedFractionEquatableTests {
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let equalityResult: Bool = lhsWrapper == rhsWrapper
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhsWrapper != rhsWrapper
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhsWrapper.isEqual(to: rhsWrapper)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhsWrapper.isUnequal(to: rhsWrapper)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Negative Infinity

extension CanonicalizedFractionEquatableTests {
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let equalityResult: Bool = lhsWrapper == rhsWrapper
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhsWrapper != rhsWrapper
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhsWrapper.isEqual(to: rhsWrapper)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhsWrapper.isUnequal(to: rhsWrapper)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Negative Zero

extension CanonicalizedFractionEquatableTests {
    @Test(
        "Negative zero equality follows rational rules",
        arguments: [
            (.negativeZero, .negativeZero, true),
            (.negativeZero, .zero, true),
            (.negativeZero, .init(0, -2), true),
            (.negativeZero, .init(-1, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func negativeZeroEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) throws {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let equalityResult: Bool = lhsWrapper == rhsWrapper
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhsWrapper != rhsWrapper
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhsWrapper.isEqual(to: rhsWrapper)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhsWrapper.isUnequal(to: rhsWrapper)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Positive Infinity

extension CanonicalizedFractionEquatableTests {
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let equalityResult: Bool = lhsWrapper == rhsWrapper
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhsWrapper != rhsWrapper
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhsWrapper.isEqual(to: rhsWrapper)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhsWrapper.isUnequal(to: rhsWrapper)
        #expect(isUnequalResult == !expected)
    }
}

// MARK: - Positive Zero

extension CanonicalizedFractionEquatableTests {
    @Test(
        "Positive zero equality follows rational rules",
        arguments: [
            (.zero, .zero, true),
            (.zero, .negativeZero, true),
            (.zero, .init(0, 2), true),
            (.zero, .init(1, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func positiveZeroEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) throws {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let equalityResult: Bool = lhsWrapper == rhsWrapper
        #expect(equalityResult == expected)
        let inequalityResult: Bool = lhsWrapper != rhsWrapper
        #expect(inequalityResult == !expected)
        let isEqualResult: Bool = try lhsWrapper.isEqual(to: rhsWrapper)
        #expect(isEqualResult == expected)
        let isUnequalResult: Bool = try lhsWrapper.isUnequal(to: rhsWrapper)
        #expect(isUnequalResult == !expected)
    }
}
