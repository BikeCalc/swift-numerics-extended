// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Hashable Tests")
internal struct Int4HashableTests {
    @Test(
        "Equal values produce equal hashes",
        arguments: [
            (1, 1),
            (-1, -1),
            (2, 2),
            (-2, -2)
        ] as Array<(Int4, Int4)>
    )
    internal func equalValuesProduceEqualHashes(
        lhs: Int4,
        rhs: Int4
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Negative Zero

extension Int4HashableTests {
    @Test("Equal negative zero values produce equal hashes")
    internal func equalNegativeZeroValuesProduceEqualHashes() {
        #expect(Int4.negativeZero.hashValue == Int4.negativeZero.hashValue)
        #expect(Set([Int4.negativeZero, Int4.negativeZero]).count == 1)
    }
}

// MARK: - Positive Zero

extension Int4HashableTests {
    @Test("Equal positive zero values produce equal hashes")
    internal func equalPositiveZeroValuesProduceEqualHashes() {
        #expect(Int4.zero.hashValue == Int4.zero.hashValue)
        #expect(Set([Int4.zero, Int4.zero]).count == 1)
    }
}
