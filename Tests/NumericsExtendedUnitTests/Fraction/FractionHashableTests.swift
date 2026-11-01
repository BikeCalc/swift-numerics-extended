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
    internal init() {}

    @Test(
        "Equal stored values produce equal hashes",
        arguments: [
            (.init(1, 2), .init(1, 2)),
            (.init(-1, 2), .init(-1, 2)),
            (.init(1, -2), .init(1, -2)),
            (.init(-1, -2), .init(-1, -2))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.init(1, 2), .init(2, 4)),
            (.init(-1, 2), .init(1, -2)),
            (.init(-1, 2), .init(-2, 4)),
            (.init(1, 2), .init(-1, -2))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.negativeInfinity, .negativeInfinity),
            (.negativeInfinity, .init(-2, 0))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.negativeZero, .negativeZero, 1),
            (.negativeZero, .init(0, -2), 2),
            (.negativeZero, .zero, 2)
        ] as Array<(Fraction<Int>, Fraction<Int>, Int)>
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
            (.infinity, .infinity),
            (.infinity, .init(2, 0))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.zero, .zero, 1),
            (.zero, .init(0, 2), 2),
            (.zero, .negativeZero, 2)
        ] as Array<(Fraction<Int>, Fraction<Int>, Int)>
    )
    internal func positiveZeroHashingFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        count: Int
    ) {
        #expect(Set([lhs, rhs]).count == count)
    }
}
