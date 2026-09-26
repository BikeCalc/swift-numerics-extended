// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Hashable Tests")
internal struct IntHashableTests {
    @Test(
        "Equal values produce equal hashes",
        arguments: [
            (1, 1),
            (-1, -1),
            (2, 2),
            (-2, -2)
        ]
    )
    internal func equalValuesProduceEqualHashes(
        lhs: Int,
        rhs: Int
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Negative Zero

extension IntHashableTests {
    @Test("Equal negative zero values produce equal hashes")
    internal func equalNegativeZeroValuesProduceEqualHashes() {
        #expect(Int.negativeZero.hashValue == Int.negativeZero.hashValue)
        #expect(Set([Int.negativeZero, Int.negativeZero]).count == 1)
    }
}

// MARK: - Positive Zero

extension IntHashableTests {
    @Test("Equal positive zero values produce equal hashes")
    internal func equalPositiveZeroValuesProduceEqualHashes() {
        #expect(Int.zero.hashValue == Int.zero.hashValue)
        #expect(Set([Int.zero, Int.zero]).count == 1)
    }
}
