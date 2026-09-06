// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Hashable Tests")
internal struct RomanHashableTests {
    @Test(
        "Equal values produce equal hashes",
        arguments: [
            (1, 1),
            (2, 2)
        ] as Array<(Roman, Roman)>
    )
    internal func equalValuesProduceEqualHashes(
        lhs: Roman,
        rhs: Roman
    ) {
        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([lhs, rhs]).count == 1)
    }
}

// MARK: - Positive Zero

extension RomanHashableTests {
    @Test("Equal positive zero values produce equal hashes")
    internal func equalPositiveZeroValuesProduceEqualHashes() {
        #expect(Roman.zero.hashValue == Roman.zero.hashValue)
        #expect(Set([Roman.zero, Roman.zero]).count == 1)
    }
}
