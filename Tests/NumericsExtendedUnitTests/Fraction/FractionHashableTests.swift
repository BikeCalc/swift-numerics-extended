// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Hashable Tests")
internal struct FractionHashableTests {
    @Test(
        "Equal stored values produce equal hashes",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(1, 2)),
            (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2)),
            (Fraction<Int>(1, -2), Fraction<Int>(1, -2)),
            (Fraction<Int>(-1, -2), Fraction<Int>(-1, -2))
        ]
    )
    internal func equalStoredValuesProduceEqualHashes(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }

    @Test(
        "Equivalent representations remain distinct hash keys",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(2, 4)),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, -2)),
            (Fraction<Int>(-1, 2), Fraction<Int>(-2, 4)),
            (Fraction<Int>(1, 2), Fraction<Int>(-1, -2))
        ]
    )
    internal func equivalentRepresentationsRemainDistinctHashKeys(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        #expect(lhs != rhs)
        #expect(Set([lhs, rhs]).count == 2)
    }
}

// MARK: - NaN

extension FractionHashableTests {
    @Test("NaN values remain distinct hash keys")
    internal func nanValuesRemainDistinctHashKeys() {
        let value: Fraction<Int> = .nan

        #expect(Set([value, value]).count == 2)
    }
}

// MARK: - Negative Infinity

extension FractionHashableTests {
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
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Negative Zero

extension FractionHashableTests {
    @Test(
        "Negative zero hashing follows stored representation rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero, 1),
            (Fraction<Int>.negativeZero, Fraction<Int>(0, -2), 2),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero, 2)
        ]
    )
    internal func negativeZeroHashingFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        count: Int
    ) {
        #expect(Set([lhs, rhs]).count == count)
    }
}

// MARK: - Positive Infinity

extension FractionHashableTests {
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
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Positive Zero

extension FractionHashableTests {
    @Test(
        "Positive zero hashing follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero, 1),
            (Fraction<Int>.zero, Fraction<Int>(0, 2), 2),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero, 2)
        ]
    )
    internal func positiveZeroHashingFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        count: Int
    ) {
        #expect(Set([lhs, rhs]).count == count)
    }
}
