// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Hashable Tests")
internal struct UInt4HashableTests {
    @Test(
        "Equal values produce equal hashes",
        arguments: [
            (1, 1),
            (2, 2),
            (7, 7),
            (15, 15)
        ] as Array<(UInt4, UInt4)>
    )
    internal func equalValuesProduceEqualHashes(
        lhs: UInt4,
        rhs: UInt4
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Positive Zero

extension UInt4HashableTests {
    @Test("Equal positive zero values produce equal hashes")
    internal func equalPositiveZeroValuesProduceEqualHashes() {
        #expect(UInt4.zero.hashValue == UInt4.zero.hashValue)
        #expect(Set([UInt4.zero, UInt4.zero]).count == 1)
    }
}
