// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Hashable Tests")
internal struct CanonicalizedFractionHashableTests {
    @Test(
        "Equivalent representations produce equal hashes",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(2, 4)),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, -2)),
            (Fraction<Int>(-1, 2), Fraction<Int>(-2, 4)),
            (Fraction<Int>(1, 2), Fraction<Int>(-1, -2))
        ]
    )
    internal func equivalentRepresentationsProduceEqualHashes(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper == rhsWrapper)
        #expect(lhsWrapper.hashValue == rhsWrapper.hashValue)
        #expect(Set([lhsWrapper, rhsWrapper]).count == 1)
    }
}

// MARK: - NaN

extension CanonicalizedFractionHashableTests {
    @Test("NaN values remain distinct hash keys")
    internal func nanValuesRemainDistinctHashKeys() {
        let value: Canonicalized<Fraction<Int>> = .init(wrappedValue: .nan)

        #expect(Set([value, value]).count == 2)
    }
}

// MARK: - Negative Infinity

extension CanonicalizedFractionHashableTests {
    @Test(
        "Negative infinity hashing follows rational rules",
        arguments: [
            (Fraction<Int>.negativeInfinity, Fraction<Int>.negativeInfinity),
            (Fraction<Int>.negativeInfinity, Fraction<Int>(-2, 0))
        ]
    )
    internal func negativeInfinityHashingFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper == rhsWrapper)
        #expect(lhsWrapper.hashValue == rhsWrapper.hashValue)
        #expect(Set([lhsWrapper, rhsWrapper]).count == 1)
    }
}

// MARK: - Negative Zero

extension CanonicalizedFractionHashableTests {
    @Test(
        "Negative zero hashing follows rational rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero),
            (Fraction<Int>.negativeZero, Fraction<Int>(0, -2)),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero)
        ]
    )
    internal func negativeZeroHashingFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper == rhsWrapper)
        #expect(lhsWrapper.hashValue == rhsWrapper.hashValue)
        #expect(Set([lhsWrapper, rhsWrapper]).count == 1)
    }
}

// MARK: - Positive Infinity

extension CanonicalizedFractionHashableTests {
    @Test(
        "Positive infinity hashing follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.infinity),
            (Fraction<Int>.infinity, Fraction<Int>(2, 0))
        ]
    )
    internal func positiveInfinityHashingFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper == rhsWrapper)
        #expect(lhsWrapper.hashValue == rhsWrapper.hashValue)
        #expect(Set([lhsWrapper, rhsWrapper]).count == 1)
    }
}

// MARK: - Positive Zero

extension CanonicalizedFractionHashableTests {
    @Test(
        "Positive zero hashing follows rational rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero),
            (Fraction<Int>.zero, Fraction<Int>(0, 2)),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero)
        ]
    )
    internal func positiveZeroHashingFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper == rhsWrapper)
        #expect(lhsWrapper.hashValue == rhsWrapper.hashValue)
        #expect(Set([lhsWrapper, rhsWrapper]).count == 1)
    }
}
