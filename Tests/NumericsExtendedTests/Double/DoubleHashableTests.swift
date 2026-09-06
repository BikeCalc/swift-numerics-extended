// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Hashable Tests")
internal struct DoubleHashableTests {
    @Test(
        "Equal values produce equal hashes",
        arguments: [
            (1.0, 1.0),
            (-1.0, -1.0),
            (0.5, 0.5),
            (-0.5, -0.5)
        ]
    )
    internal func equalValuesProduceEqualHashes(
        lhs: Double,
        rhs: Double
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - NaN

extension DoubleHashableTests {
    @Test("NaN values remain distinct hash keys")
    internal func nanValuesRemainDistinctHashKeys() {
        let value: Double = .nan

        #expect(Set([value, value]).count == 2)
    }
}

// MARK: - Negative Infinity

extension DoubleHashableTests {
    @Test("Equal negative infinity values produce equal hashes")
    internal func equalNegativeInfinityValuesProduceEqualHashes() {
        #expect(Double.negativeInfinity.hashValue == Double.negativeInfinity.hashValue)
        #expect(Set([Double.negativeInfinity, Double.negativeInfinity]).count == 1)
    }
}

// MARK: - Negative Zero

extension DoubleHashableTests {
    @Test(
        "Negative zero hashing follows floating-point rules",
        arguments: [
            (Double.negativeZero, Double.negativeZero),
            (Double.negativeZero, Double.zero)
        ]
    )
    internal func negativeZeroHashingFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Positive Infinity

extension DoubleHashableTests {
    @Test("Equal positive infinity values produce equal hashes")
    internal func equalPositiveInfinityValuesProduceEqualHashes() {
        #expect(Double.infinity.hashValue == Double.infinity.hashValue)
        #expect(Set([Double.infinity, Double.infinity]).count == 1)
    }
}

// MARK: - Positive Zero

extension DoubleHashableTests {
    @Test(
        "Positive zero hashing follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero),
            (Double.zero, Double.negativeZero)
        ]
    )
    internal func positiveZeroHashingFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}
